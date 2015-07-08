function loadFullText() {
   
}

function init() {
   var url = document.URL
   var start = url.indexOf("?session=")
   
   if (start > -1) {
      start = start + 9
      if (url.length >= start+8) {
         var sessionid = url.substr(start, 8)
         $("#sel_session").val(sessionid)
         $("#sel_export").val("html")
         $("#btn_change").click(loadTessResults)
         loadTessResults()
      }
   }
}

function markedMatchingTokens(record, dest) {
   var displayText = $("<div />")
   var tokens = record["display_".concat(dest)]
   var marked = record["marked_".concat(dest)]
   
   for (var i in marked) {
      tokens[marked[i]] = $("<span />").addClass("matched").text(tokens[marked[i]])
   }
   
   displayText.append(tokens)
   
   return(displayText.html())
}

function loadTessResultsCallback(jsondata) {   
   var tbody = $("#results_table tbody").select(0)
   tbody.find("tr").remove()
   
   for (var i in jsondata.results) {
      var row = $("<tr />")
      var res = jsondata.results[i]

      row.append($("<td />").append(res.n))
      row.append($("<td />").append(res.loc_target))
      row.append($("<td />").append(markedMatchingTokens(res, "target")))
      row.append($("<td />").append(res.loc_source))
      row.append($("<td />").append(markedMatchingTokens(res, "source")))      
      row.append($("<td />").append(res.features.join(", ")))
      row.append($("<td />").append(res.score))
      
      tbody.append(row)
   }
   
   loadMeta(jsondata.metadata)
}

function loadTessResults() {
   var session = $("#sel_session").val()
   var batch = $("#sel_batch").val()
   var page = $("#sel_page").val()
   var decimal = $("#sel_decimal").val()
   var sort = $("#sel_sort").val()
   var mode = $("#sel_export").val()

   var params = {
      session:session,
      batch:batch,
      page:page,
      decimal:decimal,
      sort:sort,
      export:mode
   }
   
   if (mode == "html") {
      params.export = "json"
   
      var tbody = $("#results_table tbody").select(0)
      tbody.find("tr").remove()
      tbody.html("<tr><td colspan='7' style='text-align:center'>loading...</td></tr>")

      $.getJSON("/cgi-bin/read-bin.pl", params, loadTessResultsCallback)
   } else {
      $("#btn_download").click()
   }
   
}

function loadMeta(meta) {
   meta.STOPLIST = meta.STOPLIST.join(", ")
   
   for (field in meta) {
      $(".".concat(field)).html(meta[field])
   }
   
   pager(meta.TOTAL, meta.PAGESIZE, meta.PAGE)
   
   $("#metadata").show()
}

function pager_goto(page, npages) {
   if (page < 1) { page = 1 }
   if (page > npages) { page = npages }
   return (function() {
      $("#sel_page").val(page)
      loadTessResults()
   })
}

function pager(nresults, pagesize, page) {
   var npages = Math.ceil(nresults/pagesize)
   
   $("#pager_msg").html([nresults, "results in", npages, "pages."].join(" "))
   $("#sel_page").val(page)

   page=parseInt(page)
   $("#pager_first").click(pager_goto(0, npages))
   $("#pager_prev").click(pager_goto(page-1, npages))
   $("#pager_next").click(pager_goto(page+1, npages))
   $("#pager_last").click(pager_goto(npages, npages))
}
