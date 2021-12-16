(function(f) {
  window.onload = f;
})(function() {
    // coords = ulx, uly, lrx, lry
    var currentPage;
    var items = document.querySelectorAll(".viewer > .viewer-gallery > .item");
    var areaElement = [];
    
    goPage(1);
    //highlightRow("#ms_fr_03951_01_1_p012_ab2");
    //resetAllHightligh();
    
    document.getElementById("next").onclick = function() {
      goPage(currentPage + 1);
    };

    document.getElementById("prev").onclick = function() {
      goPage(currentPage - 1);
    };

    /**
     * Book
     */

    function goPage(page) {
      var _dx, _sx, currentIndex = -1, dx, sx, markText;
      if(page >= 1 && page <= items.length) {
        currentPage = page;
        document.querySelector(".counter-display").textContent = currentPage + "/" + items.length;
        if((currentIndex = [].indexOf.call(items, document.querySelector(".current"))) > -1) {
          items[currentIndex].classList.remove("current");
        }
        if((_sx = [].indexOf.call(items, document.querySelector(".sx"))) > -1) {
          items[_sx].classList.remove("sx");
        }
        if((_dx = [].indexOf.call(items, document.querySelector(".dx"))) > -1) {
          items[_dx].classList.remove("dx");
        }
        if(document.querySelector(".marked")) {
          document.querySelector(".marked").classList.remove("marked");
        }
        currentIndex = currentPage - 1;
        
        if(currentPage % 2 == 1) {
          sx = currentPage - 1;
          dx = currentPage;
        } else {
          sx = currentPage - 2;
          dx = currentPage - 1;
        }

        items[currentIndex].classList.add("current");
        items[sx].classList.add("sx");
        items[dx].classList.add("dx");

        var map = items[currentIndex].querySelector("map");
          if(items[currentIndex].querySelector("area") !== null) {
            if(areaElement[currentIndex] == null) {
              areaElement[currentIndex] = new ImageMap(map);
            }
            areaElement[currentIndex].resize();
          }
        items[currentIndex].querySelectorAll('area').forEach((area) => {
          area.onclick = () => {
            var row = area.getAttribute("data-row");
            resetAllHightligh();
            highlightRow(document.querySelector(row));
          }
        });

        var attr = items[currentIndex].getAttribute("data-reading");

        if(markText = document.querySelector(".reading > .reading-body > " + attr)) {
          markText.classList.add("marked");
        }
      }
    }

    /**
     * Highlight
     */
    function highlightRow(node, color = '') {
      if(node) {
        var newElement = node.cloneNode();
        var mark = document.createElement("mark");
        var newText = document.createTextNode(node.textContent);
        mark.appendChild(newText);
        newElement.appendChild(mark);
        node.parentNode.replaceChild(newElement, node);
      }
    }

    function resetAllHightligh() {
      var marks = document.querySelectorAll("mark");
      marks.forEach((item) => {
        item.parentNode.textContent = item.textContent;
      });
    }

});