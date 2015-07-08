function populate_author(lang, dest) {

	var select_full = $("#" + lang + "_texts").get(0)
	var select_auth = $("#sel_auth_" + dest).get(0)
	
	var authors = {}
	
	for (var i=0; i<select_full.length; i++) { 
	
		var opt_this = select_full.options[i]
		
		var seg_value = opt_this.value.split(".")
		var seg_name = opt_this.text.split(" - ")
						
		authors[seg_value[0]] = seg_name[0]		
	}
	
   $(select_auth).empty()
   
	for (var i in authors) {
	
		var opt_new = new Option(authors[i], i)
		select_auth.add(opt_new)
	}
	
   populate_work(lang,dest)
}

function populate_work(lang, dest) {

	var select_full = $("#" + lang + "_texts").get(0)
	var select_auth = $("#sel_auth_" + dest).get(0)
	var select_work = $("#sel_work_" + dest).get(0)
	
	var auth_master = select_auth.options[select_auth.selectedIndex].value
	var works = {}
	
	for (var i=0; i<select_full.length; i++) { 
	
		var opt_this = select_full.options[i]
		
		var seg_value = opt_this.value.split(".")
		var seg_name = opt_this.text.split(" - ")
		
		var auth_this = seg_value[0]
		var work_this = seg_value[1]
	
		if (auth_this == auth_master) {
			
			works[work_this] = seg_name[1]
		}
	}
			
	$(select_work).empty()
	
	for (var i in works) {
	
		var opt_new = new Option(works[i], i)
		select_work.add(opt_new)
	}
			
	populate_part(lang,dest)
}

function populate_part(lang, dest) {
	
	var select_full = $("#" + lang + "_texts").get(0)
	var select_auth = $("#sel_auth_" + dest).get(0)
	var select_work = $("#sel_work_" + dest).get(0)
	var select_part = $("#sel_part_" + dest).get(0)
	
	var auth_master = select_auth.options[select_auth.selectedIndex].value
	var work_master = select_work.options[select_work.selectedIndex].value
	var parts = {};
	
	for (var i=0; i<select_full.length; i++) { 
	
		var opt_this = select_full.options[i]
		
		var seg_value = opt_this.value.split(".");
		var seg_name = opt_this.text.split(" - ");
		
		var auth_this = seg_value[0];
		var work_this = seg_value[1];
						
		if (auth_this == auth_master && work_this == work_master) {
			
			if (seg_name.length > 2) {
				
				parts[seg_name[2]] = opt_this.value
			}
			else {
			
				parts["Full Text"] = opt_this.value
			}
		}
	}
	
	$(select_part).empty()
	
	for (var i in parts) {
	
		var opt_new = new Option(i, parts[i])
		select_part.add(opt_new)
	}		
}

function populate_feature(features, sel_position) {

	var list_feature = document.getElementsByName('feature')[0];

	for (var feat in features) {
		var opt = document.createElement('option');
		opt.value = feat;
		opt.text = features[feat];

		list_feature.add(opt);
		
		list_feature.selectedIndex=sel_position;
	}
}

function set_defaults(lang, selected) {
		
	for (dest in selected) {      	
   	var select_auth = $("#sel_auth_" + dest).get(0)
   	var select_work = $("#sel_work_" + dest).get(0)
   	var select_part = $("#sel_part_" + dest).get(0)
		
		var seg = selected[dest].split('.');
		var auth = seg[0];
		var work = seg[1];
		
		for (var i=0; i < select_auth.options.length; i++) {
		
			if (select_auth.options[i].value == auth) {
			
				select_auth.selectedIndex = i;
			}
		}
		
		populate_work(lang[dest],dest);

		for (var i=0; i < select_work.options.length; i++) {
		
			if (select_work.options[i].value == work) {
		
				select_work.selectedIndex = i;
			}
		}
		
		populate_part(lang[dest],dest);

		for (var i=0; i < select_part.options.length; i++) {
		
			if (select_part.options[i].value == selected[dest]) {
			
				select_part.selectedIndex = i;
			}
		}
	}	
}

function toggle_advanced(isAdv) {

   var msg = ""

   if (isAdv) {
      msg = "show advanced"
      $(".advanced").hide()
   } else {
      msg = "hide advanced"
      $(".advanced").show()
   }

   $("#msg_advanced").html(msg)
}

function init_progress_bar() {
	var popup_frame = jQuery("<div />", {id: "pbar_popup_frame"})
	var popup = jQuery("<div />", {id: "pbar_popup"})
	var msg_frame = jQuery("<div />", {id: "pbar_msg_frame"})
	var msg = jQuery("<div />", {id: "pbar_msg"})
	msg.append("<p>Please wait...</p>")
	var pbar_frame = jQuery("<div />", {id: "pbar_pb_frame"})
	var pbar = jQuery("<progress />", {
		id: "pbar_pb",
		max: "100",
		value: "0"
	})

	pbar_frame.append(pbar)
	msg_frame.append(msg)
	popup.append(msg_frame)
	popup.append(pbar_frame)
	popup_frame.append(popup)

	$("#container").append(popup_frame)
}

function update_progress(pbdata) {
   $("#pbar_pb").attr("value", pbdata.progress)
   $("#pbar_msg").html(pbdata.msg)
}

function progress_loop(session, cb_cont, cb_done, cb_fail) {
   $.getJSON("/cgi-bin/ajax-get-progress.pl", {"session":session}, function(pbdata) {      
      if (pbdata.status == "DONE") {
         if (typeof(cb_done) == "function") {
            cb_done(pbdata)
         }
      } else if (pbdata.status == "NOT FOUND") {
         if (typeof(cb_fail) == "function") {
            cb_fail(pbdata)
         }
      } else if (pbdata.status == "READ ERROR") {
         return
      }
      if ($("#pbar_popup_frame").html != undefined) {
         update_progress(pbdata)
      }
      if (typeof(cb_cont) == "function") {
         cb_cont(pbdata)
      }
   })
}

function launch_search() {
	$.getJSON("/cgi-bin/ajax-launch-search.pl", {
			source: $("#sel_part_source").val(),
			target: $("#sel_part_target").val(),
			unit: $("#sel_unit").val(),
			feature: $("#sel_feature").val(),
			stopwords: $("#sel_stop").val(),
			stbasis: $("#sel_stbasis").val(),
			score: $("#sel_score").val(),
			dist: $("#sel_dist").val(),
			dibasis: $("#sel_dibasis").val()
		},
      function(resp) {
         init_progress_bar()
         
         var loophandle
         var waitflag = false
         
         cb_continue = function(pbdata) {
            waitflag = false
         }
         
         cb_done = function(pbdata) {
            $("#pbar_popup_frame").remove()
            clearInterval(loophandle)
            window.location = "/results.html?session=" + resp.session
         }
         
         pbcycle = function(){
            if (waitflag == false) {
               waitflag = true
               progress_loop(resp.session, cb_continue, cb_done)
            }
         }
         
         loophandle = setInterval(pbcycle, 400)
      }
   )
}

function init_search_page() {
   var sentinel = 0
   var l = "la"
   
   var url = document.URL
   var start = url.indexOf("?lang=")
   
   if (start > -1) {
      start = start + 6
      if (url.length > start) {
         l = url.substr(start, url.length-start)
      }
   }

   function checkSentinel() {
      sentinel += 1
      if (sentinel == 2) {
         populate_author(lang["target"], "target")
         populate_author(lang["source"], "source")
         set_defaults(lang, selected);               
      }
   }
   
   function loadTextList(l) {
      var elem = $("<select />")
      elem.attr("id", l + "_texts")
      elem.load("/textlist." + l + ".r.html", function() {
         $("#textlists").append(elem)
         checkSentinel()
      })
   }
   
   $("#nav_main").load("/nav_main.html", function(){
      $("#nav_main_search").addClass("nav_selected")
   })
   $("#nav_sub").load("/nav_search.html", function(){
      $("#nav_search_" + l).addClass("nav_selected")
   })

   $.getJSON("/search-presets.json", function(data) {
      lang = data[l].lang
      selected = data[l].selected
      feature = data[l].feature
      $("#h1_title").html(data[l].title)
      $("#div_description").html(data[l].description)
      
      loadTextList(lang["source"])
      if (lang["source"] != lang["target"]) {
         loadTextList(lang["target"])
      } else {
         checkSentinel()
      }
      
      $("#sel_feature").html("")
      for (var k in feature) {
        $("#sel_feature").append($("<option />").val(k).text(feature[k])) 
      }
      
      $("#sel_auth_source").change(function() {
         populate_work(lang["source"], "source")
      })
      $("#sel_work_source").change(function() {
         populate_part(lang["source"], "source")
      })
      $("#sel_auth_target").change(function() {
         populate_work(lang["target"], "target")
      })
      $("#sel_work_target").change(function() {
         populate_part(lang["target"], "target")
      })
   })
   
   $("#switch_advanced").click(function(){
      toggle_advanced(isAdvanced)
      isAdvanced = ! isAdvanced
   })

   $("#btn_search").click(launch_search)
}