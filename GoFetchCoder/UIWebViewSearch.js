//<script src="base64.js"></script>




var uiWebview_SearchResultCount = 0;

function uiWebview_HighlightAllOccurencesOfStringForElement(element,keyword) {

    if (element) {
        if (element.nodeType == 3) {        // Text node
            while (true) {
            //if (counter < 1) {
            var value = element.nodeValue;  // Search for keyword in text node
            var idx = value.toLowerCase().indexOf(keyword);

            if (idx < 0) break;             // not found, abort
                

            //(value.split);

            //we create a SPAN element for every parts of matched keywords
            var span = document.createElement("span");
            var text = document.createTextNode(value.substr(idx,keyword.length));
            span.appendChild(text);

            span.setAttribute("class","uiWebviewHighlight");
            span.style.backgroundColor="yellow";
            span.style.color="black";

            uiWebview_SearchResultCount++;    // update the counter

            text = document.createTextNode(value.substr(idx+keyword.length));
            element.deleteData(idx, value.length - idx);
            var next = element.nextSibling;
            element.parentNode.insertBefore(span, next);
            element.parentNode.insertBefore(text, next);
            element = text;
            window.scrollTo(0,span.offsetTop);

        }
    } else if (element.nodeType == 1) { // Element node
        if (element.style.display != "none" && element.nodeName.toLowerCase() != 'select') {
            for (var i=element.childNodes.length-1; i>=0; i--) {
                uiWebview_HighlightAllOccurencesOfStringForElement(element.childNodes[i],keyword);
            }
        }
    }
}
}

// the main entry point to start the search
function uiWebview_HighlightAllOccurencesOfString(keyword) {

    uiWebview_RemoveAllHighlights();
    uiWebview_HighlightAllOccurencesOfStringForElement(document.body, keyword.toLowerCase());
}

// helper function, recursively removes the highlights in elements and their childs
function uiWebview_RemoveAllHighlightsForElement(element) {
if (element) {
    if (element.nodeType == 1) {
        if (element.getAttribute("class") == "uiWebviewHighlight") {
            var text = element.removeChild(element.firstChild);
            element.parentNode.insertBefore(text,element);
            element.parentNode.removeChild(element);
            return true;
        } else {
            var normalize = false;
            for (var i=element.childNodes.length-1; i>=0; i--) {
                if (uiWebview_RemoveAllHighlightsForElement(element.childNodes[i])) {
                    normalize = true;
                }
            }
            if (normalize) {
                element.normalize();
            }
        }
    }
}
return false;
}
// the main entry point to remove the highlights
function uiWebview_RemoveAllHighlights() {
    uiWebview_SearchResultCount = 0;
    uiWebview_RemoveAllHighlightsForElement(document.body);
}

var selectedText = "";
var selStart = 0;
var selEnd = 0;
var count = 0;


function getHighlightedString() {
    var selectedText        = typeof(window.getSelection()+'');
//    start = text.anchorOffset;
//    end = text.focusOffset;
//    selectedText    = text.anchorNode.textContent.substr(text.anchorOffset, text.focusOffset);
}
var rangex = 0;
var rangey = 0;
function highlight(){
    var sel = window.getSelection();
    if (!sel.isCollapsed) {
        var selRange = sel.getRangeAt(0);
        
        var priorRange = selRange.cloneRange();
        
        priorRange = sel.getRangeAt(0).cloneRange();
        
        priorRange.selectNodeContents(document.body);
        priorRange.setEnd(selRange.startContainer, selRange.startOffset);
       
        
        selStart = priorRange.toString().length;
        selEnd = selStart + selRange.toString().length;
        
        document.designMode = "on";
        sel.removeAllRanges();
        sel.addRange(selRange);
        
        
   
        document.execCommand("HiliteColor", false, "#ffffcc");
        sel.removeAllRanges();
        document.designMode = "off";
    }
}

function getTextNodesIn(node) {
    var textNodes = [];
    if (node.nodeType == 3) {
        textNodes.push(node);
    } else {
        var children = node.childNodes;
        for (var i = 0, len = children.length; i < len; ++i) {
            textNodes.push.apply(textNodes, getTextNodesIn(children[i]));
        }
    }
    return textNodes;
}

var jsonString = "";
var arrayLen = 0;

var startInt = 0;
var startEnd = 0;

function setHighlight(encodedArray){

    jsonString  = Base64.decode(encodedArray);
    var arrayHighlights = JSON.parse(jsonString);
    
    for(var i = 0, len = arrayHighlights.length; i < len; i++){
        startInt = arrayHighlights[i].startIndex;
        endInt = arrayHighlights[i].endIndex;
        if(startInt != 0){
            setItemHighlight(startInt, endInt);
        }
        
    }
    
    arrayLen = arrayHighlights.length;
    
}

function setItemHighlight(start, end){

    var range = document.createRange();
    range.selectNodeContents(document.body);
    

    var textNodes = getTextNodesIn(document.body);
    var foundStart = false;
    var charCount = 0, endCharCount;
    
    for (var i = 0, textNode; textNode = textNodes[i++]; ) {
        count = count + 1;
        endCharCount = charCount + textNode.length;
        if (!foundStart && start >= charCount && (start < endCharCount || (start == endCharCount && i <= textNodes.length))) {
            range.setStart(textNode, start - charCount);
            foundStart = true;
        }
        if (foundStart && end <= endCharCount) {
            range.setEnd(textNode, end - charCount);
            break;
        }
        charCount = endCharCount;
    }
    
    var sel = window.getSelection();
    sel.removeAllRanges();
    sel.addRange(range);
    
    document.designMode = "on";
    document.execCommand("HiliteColor", false, "#ffffcc");
    document.designMode = "off";

}


var Base64={_keyStr:"ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/=",encode:function(e){var t="";var n,r,i,s,o,u,a;var f=0;e=Base64._utf8_encode(e);while(f<e.length){n=e.charCodeAt(f++);r=e.charCodeAt(f++);i=e.charCodeAt(f++);s=n>>2;o=(n&3)<<4|r>>4;u=(r&15)<<2|i>>6;a=i&63;if(isNaN(r)){u=a=64}else if(isNaN(i)){a=64}t=t+this._keyStr.charAt(s)+this._keyStr.charAt(o)+this._keyStr.charAt(u)+this._keyStr.charAt(a)}return t},decode:function(e){var t="";var n,r,i;var s,o,u,a;var f=0;e=e.replace(/[^A-Za-z0-9\+\/\=]/g,"");while(f<e.length){s=this._keyStr.indexOf(e.charAt(f++));o=this._keyStr.indexOf(e.charAt(f++));u=this._keyStr.indexOf(e.charAt(f++));a=this._keyStr.indexOf(e.charAt(f++));n=s<<2|o>>4;r=(o&15)<<4|u>>2;i=(u&3)<<6|a;t=t+String.fromCharCode(n);if(u!=64){t=t+String.fromCharCode(r)}if(a!=64){t=t+String.fromCharCode(i)}}t=Base64._utf8_decode(t);return t},_utf8_encode:function(e){e=e.replace(/\r\n/g,"\n");var t="";for(var n=0;n<e.length;n++){var r=e.charCodeAt(n);if(r<128){t+=String.fromCharCode(r)}else if(r>127&&r<2048){t+=String.fromCharCode(r>>6|192);t+=String.fromCharCode(r&63|128)}else{t+=String.fromCharCode(r>>12|224);t+=String.fromCharCode(r>>6&63|128);t+=String.fromCharCode(r&63|128)}}return t},_utf8_decode:function(e){var t="";var n=0;var r=c1=c2=0;while(n<e.length){r=e.charCodeAt(n);if(r<128){t+=String.fromCharCode(r);n++}else if(r>191&&r<224){c2=e.charCodeAt(n+1);t+=String.fromCharCode((r&31)<<6|c2&63);n+=2}else{c2=e.charCodeAt(n+1);c3=e.charCodeAt(n+2);t+=String.fromCharCode((r&15)<<12|(c2&63)<<6|c3&63);n+=3}}return t}}
    

var scrollTop = 0;
var start1 = 0;
var end1 = 0;
var selString = "";
function bookmark(){
    var sel = window.getSelection();
    if (!sel.isCollapsed) {
        var selRange = sel.getRangeAt(0);
        
        //get the selected string.
        if (sel.rangeCount) {
            var container = document.createElement("div");
            for (var i = 0, len = sel.rangeCount; i < len; ++i) {
                container.appendChild(sel.getRangeAt(i).cloneContents());
            }
            html = container.innerHTML;
        }
        selString = html;
        
        
        //get the range for content poistion from 0.
        var priorRange = selRange.cloneRange();
        
        priorRange = sel.getRangeAt(0).cloneRange();
        
        priorRange.selectNodeContents(document.body);
        priorRange.setEnd(selRange.startContainer, selRange.startOffset);
        
        
        selStart = priorRange.toString().length;
        selEnd = selStart + selRange.toString().length;
        
        sel.removeAllRanges();
        sel.addRange(selRange);
        
        
        sel.removeAllRanges();
      
    }
}


function showBookmark(start, end){
    start1 = start;
    end1 = end;
    
    var range = document.createRange();
    range.selectNodeContents(document.body);
    
    
    var textNodes = getTextNodesIn(document.body);
    var foundStart = false;
    var charCount = 0, endCharCount;
    
    for (var i = 0, textNode; textNode = textNodes[i++]; ) {
        count = count + 1;
        endCharCount = charCount + textNode.length;
        if (!foundStart && start >= charCount && (start < endCharCount || (start == endCharCount && i <= textNodes.length))) {
            range.setStart(textNode, start - charCount);
            foundStart = true;
        }
        if (foundStart && end <= endCharCount) {
            range.setEnd(textNode, end - charCount);
            break;
        }
        charCount = endCharCount;
    }
    
    var sel = window.getSelection();
    sel.removeAllRanges();
    sel.addRange(range);
    range.collapse(true);
     var rects, rect;
     var x = 0, y = 0;
    

    if (x == 0 && y == 0) {
        var span = document.createElement("span");
        if (span.getClientRects) {
            // Ensure span has dimensions and position by
            // adding a zero-width space character
            span.appendChild( document.createTextNode("\u200b") );
            range.insertNode(span);
            rect = span.getClientRects()[0];
            x = rect.left;
            y = rect.top;
            
            scrollTop = span.offsetTop;

            
            var spanParent = span.parentNode;
            spanParent.removeChild(span);
            
            // Glue any broken text nodes back together
            spanParent.normalize();
        }
    }
    }
