async function confirmExportWord() {
  // Read content from the live preview DOM (not from state)
  // This ensures Word pages match the HTML preview exactly
  var livePreview = document.getElementById('livePreview');
  if (!livePreview) return;

  var exportPages = Array.from(livePreview.querySelectorAll('.proposal-page'));
  if (!exportPages.length) return;

  // Helper: convert a DOM element to WordprocessingML paragraphs
  function escXml(t) { return t.replace(/&/g,'&amp;').replace(/</g,'&lt;').replace(/>/g,'&gt;'); }

  function makeRpr(el) {
    var rpr = '<w:sz w:val="21"/><w:szCs w:val="21"/>';
    var computed = window.getComputedStyle(el);
    var fw = computed.fontWeight;
    if (fw === 'bold' || fw === '700' || fw >= 600) rpr += '<w:b/><w:bCs/>';
    if (computed.textDecoration.includes('underline') || computed.textDecorationLine.includes('underline')) rpr += '<w:u w:val="single"/>';
    var fs = parseFloat(computed.fontSize);
    if (fs && fs < 12) rpr += '';  // keep default 10.5pt
    return rpr;
  }

  function makePpr(rpr, isList) {
    var ppr = '<w:pPr><w:autoSpaceDE w:val="0"/><w:autoSpaceDN w:val="0"/><w:adjustRightInd w:val="0"/><w:spacing w:line="276" w:lineRule="auto"/>';
    if (isList) ppr += '<w:numPr><w:ilvl w:val="0"/><w:numId w:val="36"/></w:numPr>';
    ppr += '<w:rPr>' + rpr + '</w:rPr></w:pPr>';
    return ppr;
  }

  function textToWp(text, rpr, isList) {
    var ppr = makePpr(rpr, isList);
    return '<w:p>' + ppr + '<w:r><w:rPr>' + rpr + '</w:rPr><w:t xml:space="preserve">' + escXml(text) + '</w:t></w:r></w:p>';
  }

  function emptyWp() {
    return '<w:p><w:pPr><w:autoSpaceDE w:val="0"/><w:autoSpaceDN w:val="0"/><w:adjustRightInd w:val="0"/><w:spacing w:line="276" w:lineRule="auto"/><w:rPr><w:sz w:val="21"/><w:szCs w:val="21"/></w:rPr></w:pPr></w:p>';
  }

  // Walk a DOM element and extract paragraphs as WordML
  function elementToParas(el) {
    var paras = [];
    if (!el) return paras;

    // Skip non-content elements
    if (el.classList && (el.classList.contains('hti-header') || el.classList.contains('page-footer') ||
        el.classList.contains('page-num') || el.classList.contains('sec-handle') ||
        el.classList.contains('hti-page-num'))) return paras;

    var tag = el.tagName ? el.tagName.toUpperCase() : '';

    // List items
    if (tag === 'LI') {
      var text = el.textContent.trim();
      if (!text) return paras;
      var rpr = makeRpr(el);
      var parentList = el.closest('ul, ol');
      var isBullet = parentList && parentList.tagName === 'UL';
      var isOrdered = parentList && parentList.tagName === 'OL';
      // Use appropriate numId: bullets=36 for inclusions, 33 for products, 34 for procedures; numbered=35 for add options
      var numId = 36;
      if (parentList && parentList.classList.contains('products-list')) numId = 33;
      if (parentList && parentList.closest('.procedure-block')) numId = 34;
      if (parentList && parentList.closest('.add-options-section')) numId = 35;
      var ppr = '<w:pPr><w:autoSpaceDE w:val="0"/><w:autoSpaceDN w:val="0"/><w:adjustRightInd w:val="0"/><w:spacing w:line="276" w:lineRule="auto"/>';
      ppr += '<w:numPr><w:ilvl w:val="0"/><w:numId w:val="' + numId + '"/></w:numPr>';
      ppr += '<w:rPr>' + rpr + '</w:rPr></w:pPr>';
      paras.push('<w:p>' + ppr + '<w:r><w:rPr>' + rpr + '</w:rPr><w:t xml:space="preserve">' + escXml(text) + '</w:t></w:r></w:p>');
      return paras;
    }

    // Block elements that should be their own paragraph
    if (tag === 'P' || tag === 'DIV' || tag === 'BR') {
      if (tag === 'BR') { paras.push(emptyWp()); return paras; }

      // Check if this is a container with children
      var children = el.children;
      var hasBlockChildren = false;
      for (var c = 0; c < children.length; c++) {
        var ct = children[c].tagName ? children[c].tagName.toUpperCase() : '';
        if (ct === 'DIV' || ct === 'P' || ct === 'UL' || ct === 'OL' || ct === 'TABLE') {
          hasBlockChildren = true;
          break;
        }
      }

      if (hasBlockChildren) {
        // Recurse into children
        for (var c = 0; c < el.childNodes.length; c++) {
          var child = el.childNodes[c];
          if (child.nodeType === 1) {
            paras = paras.concat(elementToParas(child));
          } else if (child.nodeType === 3 && child.textContent.trim()) {
            var rpr = makeRpr(el);
            paras.push(textToWp(child.textContent.trim(), rpr, false));
          }
        }
      } else {
        // Leaf block element — make it a paragraph
        var text = el.textContent.trim();
        if (text || tag === 'P') {
          var rpr = makeRpr(el);
          paras.push(textToWp(text, rpr, false));
        }
      }
      return paras;
    }

    // Lists
    if (tag === 'UL' || tag === 'OL') {
      for (var c = 0; c < el.children.length; c++) {
        paras = paras.concat(elementToParas(el.children[c]));
      }
      return paras;
    }

    // Inline or unknown — treat as paragraph
    if (el.textContent && el.textContent.trim()) {
      var rpr = makeRpr(el);
      paras.push(textToWp(el.textContent.trim(), rpr, false));
    }

    return paras;
  }

  // Build all pages
  var allPageParas = [];
  exportPages.forEach(function(page, pi) {
    var ec = page.querySelector('.export-content');
    if (!ec) return;

    var pageParas = [];
    // Walk direct children of export-content
    for (var i = 0; i < ec.childNodes.length; i++) {
      var child = ec.childNodes[i];
      if (child.nodeType === 1) {
        pageParas = pageParas.concat(elementToParas(child));
      } else if (child.nodeType === 3 && child.textContent.trim()) {
        pageParas.push(textToWp(child.textContent.trim(), '<w:sz w:val="21"/><w:szCs w:val="21"/>', false));
      }
    }

    // Add page break before this page (except first)
    if (pi > 0 && pageParas.length > 0) {
      // Insert page break before first paragraph of this page
      var firstPara = pageParas[0];
      firstPara = firstPara.replace('<w:pPr>', '<w:pPr><w:pageBreakBefore/>');
      pageParas[0] = firstPara;
    }

    allPageParas = allPageParas.concat(pageParas);
  });

  // Load template
  var templateBytes = Uint8Array.from(atob(DOCX_TEMPLATE_B64), function(c) { return c.charCodeAt(0); });
  var zip = await JSZip.loadAsync(templateBytes);
  var docXml = await zip.file('word/document.xml').async('string');

  // Extract sectPr
  var sectPrMatch = docXml.match(/<w:sectPr[\s\S]*?<\/w:sectPr>/);
  var sectPr = sectPrMatch ? sectPrMatch[0] : '';

  // Update date in header2
  var fmtDate = new Date().toLocaleDateString('en-US', { year: 'numeric', month: 'long', day: 'numeric' });
  var header2Xml = await zip.file('word/header2.xml').async('string');
  var updatedHeader2 = header2Xml.replace(/(?:January|February|March|April|May|June|July|August|September|October|November|December)\s+\d{1,2},\s+\d{4}/, fmtDate);
  zip.file('word/header2.xml', updatedHeader2);

  // Build new body
  var bodyContent = allPageParas.join('') + sectPr;
  var newDocXml = docXml.replace(/<w:body>[\s\S]*<\/w:body>/, '<w:body>' + bodyContent + '</w:body>');
  zip.file('word/document.xml', newDocXml);

  var blob = await zip.generateAsync({ type: 'blob', mimeType: 'application/vnd.openxmlformats-officedocument.wordprocessingml.document' });
  var projectName = state.projectName || 'Draft';
  var filename = 'HTI_Proposal_' + projectName.replace(/[^a-zA-Z0-9]/g, '_') + '_' + new Date().toISOString().split('T')[0] + '.docx';
  saveAs(blob, filename);
  closeExportPreview();
});
  paras.push(wp('', { bold: true }));
  paras.push(emptyP());

  // Cost (header bold, description bold, amount normal)
