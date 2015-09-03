<%-- 
    Document   : index
    Created on : Aug 25, 2015, 11:43:52 PM
    Author     : chenwesley
--%>

<!DOCTYPE html>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" import="edu.pccu.Movie.*,java.util.*"%>
<html>
        <head>
        <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
        <title>電影訂票平台</title>
        <link href="http://img.sj33.cn/uploads/allimg/201206/20120611093440396.png" rel="shortcut icon">
        <link href="../css/jquery-ui-1.11.2.min.css" rel="stylesheet" type="text/css">
        <link href="css/reset.css" rel="stylesheet" type="text/css">
        <link href="css/header_141226.css" rel="stylesheet" type="text/css">
        <link href="css/footer_141226.css" rel="stylesheet" type="text/css">
        <link href="css/main_141226.css" rel="stylesheet" type="text/css">
        <link href="css/search_141226.css" rel="stylesheet" type="text/css">
        <link href="css/font-awesome.css" rel="stylesheet" type="text/css">
        <link href="css/lightbox.css" rel="stylesheet" type="text/css">
        <script type="text/javascript" src="../js/jquery-1.11.2.min.js"></script>
        <script type="text/javascript" src="../js/jquery-ui-1.11.2.min.js"></script>
        <link href="CalendarControl.css" rel="stylesheet" type="text/css">
		<script src="CalendarControl.js" language="javascript"></script>
     
        
        
        <script type="text/javascript">
            
    // common
        // 新增日期
            function date_addDay(dateString, val) {
                
                var tDate = new Date(dateString);
                tDate.setDate(tDate.getDate() + val);

                return date_getString(tDate);
            }
        //傳入 data and delimiter 值
            function date_getString(date, delimiter) {
                var t = '-';     
                if (delimiter)       //如果 delimiter 為ture
                    t = delimiter;   // delimiter = '-'

                var y = date.getFullYear();
                var m = date.getMonth() + 1;
                var d = date.getDate();

                return y + t + padLeft(m, 2) + t + padLeft(d, 2);
            }
            
            function date_today() {
                
                return date_getString(new Date());
            }
    
        // 新增 選項對於所有的表單        
            function select_setOptions(objId, optionItems, defVal, firstVal, firstText) {
                var objId =""; // 要更新的項目
                var optionItems = "";
                var defVal = " ";//default值
                var defVal = " ";
                var obj = $('#' + objId);
                obj.find('option').remove().end();
                
                if (firstText)
                    obj.append('<option value="' + firstVal + '">' + firstText + '</option>');
                    $.each(optionItems, function (idx, item) {
                    obj.append('<option value="' + item.key + '">' + item.value + '</option>');
                     });
                     
                if (defVal)
                    obj.val(defVal);
            }
            
        // str字串長度 >= len 輸出 str 否則左邊加上 '0'
            
            function padLeft(str, len) {
                str = '' + str;
                return str.length >= len ? str : padLeft('0' + str, len);
            }
        // 補字串 '0'
            function padRight(str, len) {
                str = '' + str;
                return str.length >= len ? str : padRight(str + '0', len);
            } 
        // 系統錯誤訊息
            function printMsg(msg) {
                if ($('#sys_debugMsg').length) {
                    
                }
                else {
                    $(document.body).prepend('<div id="sys_debugMsg"></div>');
                }
                
                $('#sys_debugMsg').text($('#sys_debugMsg').text() + msg);
            }

            // 電影
            
            function findMovieGroupsByLocation() {
                
                $.getJSON(                      
                            'http://home.ezding.com.tw/func/ajax_mymovie.php',
                            {'func': 'findMovieGroupByLocation', 
                             'data': {'locationCode': $('#location').val()}},

                                function (data) {

                                    if (data.errorCode && data.errorCode === '0000')

                                        select_setOptions('mgId', data.msg, '', '', '選擇電影');
                                    }
                        );
            }
            
            function findSessionDatesByMovieGroupAndLocation(mgId, item1) {
                    if ($('#location').val() === '') {
                        alert('請先選擇地區');
                        return;
                    }
                    $.getJSON('http://home.ezding.com.tw/func/ajax_mymovie.php',
                             {'func': 'findSessionDatesByMovieGroupAndLocation', 
                              'data': {'mgId'        : $('#mgId').val(), 
                                       'locationCode': $('#location').val()}},
                
                    function (data) {
                        if (data.errorCode && data.errorCode === '0000') {
                            
                            var dateAry = [];
                            $.each(data.msg, function (idx, item) {
                                if (item.key < date_today()) {
                                    
                                }
                                else if (item.key === date_today()) {
                                    dateAry.push(
                                                {'key'  : item.key, 
                                                 'value': '今天'    }
                                                                        );
                                }
                                else {
                                    dateAry.push(
                                                {'key': item.key, 
                                                 'value': item.value }
                                                                         );
                                }
                            });
                            
                            select_setOptions('sessionDate', dateAry, '', '', '選擇日期');
                        }
                    }
                );
            }
            
           
        //  改變開始時間 
            function changeStartTime(selectedDate) {
                var d = new Date();
                var nowHour = d.getHours();
                var nowMin = d.getMinutes();
                var begin;

            //場次日選今天,將搜尋時間(小時)設定為現在以後
                if (selectedDate === date_today()) {
                    if (nowHour < 7)
                        nowHour = 7;
                    begin = nowHour;
                }/* end if 場次日期為今天 */
                else {
                    begin = 7;
                }

                var sessionTimeStart = $('#sessionTimeStart');
                
                $('option', sessionTimeStart).remove();
                
                $(sessionTimeStart).append('<option value="">時段(起)</optioin>');
                
                for (var i = begin; i <= 30; i++) {
                    var show;
                    var show2;
                    if (i < 10) {
                        show = "0" + i + ":00";
                        show2 = "0" + i + ":30";
                    }
                    else if (i >= 24) {
                        show = "0" + (i - 24) + ":00";
                        show2 = "0" + (i - 24) + ":30";
                    }
                    else {
                        show = i + ":00";
                        show2 = i + ":30";
                    }

                    if (i === nowHour && nowMin > 30) {
                        $(sessionTimeStart).append('<option value="' + show2 + '">' + show2 + '</option>');
                    }
                    else if (i === 30) {
                        $(sessionTimeStart).append('<option value="' + show + '">' + show + '</option>');
                    }
                    else {
                        $(sessionTimeStart).append('<option value="' + show + '">' + show + '</option>');
                        $(sessionTimeStart).append('<option value="' + show2 + '">' + show2 + '</option>');
                    }
                }/* end for */
            }/* end function changeStartTime */
            
            var minArray = [":00", ":30"];
            
            function changeEndTime(selectedStartTime) {
                var selectedHour = parseInt(selectedStartTime.substr(0, 2), 10);
                var selectedMin = selectedStartTime.substr(3, 4);

                if (selectedMin === '30')
                    selectedHour += 1;
                if (selectedHour < 7)
                    selectedHour += 24;

                var sessionTimeEnd = $('#sessionTimeEnd');
                $('option', sessionTimeEnd).remove();
                $(sessionTimeEnd).append('<option value="">時段(迄)</optioin>');
                for (var i = selectedHour; i <= 30; i++) {
                    var show;
                    var show2;

                    if (selectedHour < 7)
                        selectedHour += 24;
                    if (i >= 24)
                        selectedHour -= 24;

                    show = padLeft(selectedHour, 2) + minArray[0];
                    show2 = padLeft(selectedHour, 2) + minArray[1];

                    $(sessionTimeEnd).append('<option value="' + show + '">' + show + '</option>');
                    $(sessionTimeEnd).append('<option value="' + show2 + '">' + show2 + '</option>');
                    selectedHour++;
                }
                if (selectedMin == '00')
                    $("#sessionTimeEnd option[value='" + selectedStartTime + "']").remove();
            }
            

            
            
        // 選電影 判斷 空值 跳出警示
            function searchMovieByLocation() {
        	
        	
             alert("go");
             alert($("#location").val());
//              var location = document.getElementById('location');
//              if(location.value == '')
//              {
//                 message = message + '姓名不能為空白\n';
//                 alert(message);
//                 flag = false; 
//              }
                 if ($('#location').val() == '') {
                     alert('請選擇地區');
                     return;
               }
                
                 if ($('#mgId').val() == '') {
                    alert('請選擇電影');
                    return;
                }
                if ($movie_select('#sessionDate').val() == '') {
                    alert('請選擇日期');
                    return;
                }
                if ($movie_select('#ticketQuantity').val() == '') {
                    alert('請選擇人數');
                    return;
                }
                if ($movie_select('#sessionTimeStart').val() == '') {
                    alert('請選擇時間');
                    return;
                
        		}
                //Url產生機
                
                var url = "http://www.ezding.com.tw/wfs.do?action=find.seats.by.location.moviegroup.sessionTime";
                url += "&location=" + $('#location').val();
                url += "&mgId=" + $('#mgId').val();
                url += "&sessionDate=" + $('#sessionDate').val();
                url += "&sessionTimeStart=" + $('#sessionTimeStart').val();
                url += "&sessionTimeEnd=" + $('#sessionTimeEnd').val();
                url += "&ticketQuantity=" + $('#ticketQuantity').val();

                location.href = url;
            }
            function check_data()
            {
               var flag = true;
               var message = '';

               // ---------- Check ----------
               var location = document.getElementById('location');
               if(location.value=='')
               {
                  message = message + '地區不能為空白\n';
                  flag = false;
               }
                // ---------- Check ----------
                var mgId = document.getElementById('mgId');
                if(mgId.value=='')
                {
                   message = message + '電影不能為空白\n';
                   flag = false;
               }
                var ticketQuantity = document.getElementById('ticketQuantity');
                if(ticketQuantity.value=='')
                {
                   message = message + '人數不能為空白\n';
                   flag = false;
               } 
               /* 
                var sessionTimeStart = document.getElementById('sessionTimeStart');
                if(sessionTimeStart.value  =='')
                {
                   message = message + '時間不能為空白\n';
                   flag = false;
               }
                var sessionTimeEnd = document.getElementById('sessionTimeEnd');
                if(sessionTimeEnd.value  =='')
                {
                   message = message + '時間不能為空白\n';
                   flag = false;
               }
                */
               var sessionList = document.getElementById('sessionList');
               if(sessionList.value  =='')
               {
                  message = message + '場次不能為空白\n';
                  flag = false;
               }           
               if(!flag) 
               {
                  alert(message);
               }
               if(flag) 
               {
            	   movie_select.submit();
               }
               return flag;
            }


            function findShowingMoviesByCinemaId() {
                $.getJSON('http://home.ezding.com.tw/func/ajax_mymovie.php',
                        {'func': 'findShowingMoviesByCinemaId', 'data': {'cinemaId': $('#cinemaId').val()}},
                function (data) {
                    if (data.errorCode && data.errorCode === '0000')
                        select_setOptions('movieId', data.msg, '', '', '影片');
                }
                );
            }
            function findShowingShowdatesByCinemaIdAndMovieId() {
                $.getJSON('http://home.ezding.com.tw/func/ajax_mymovie.php',
                        {'func': 'findShowingShowdatesByCinemaIdAndMovieId', 'data': {'cinemaId': $('#cinemaId').val(), 'movieId': $('#movieId').val()}},
                function (data) {
                    if (data.errorCode && data.errorCode === '0000')
                        select_setOptions('showDate', data.msg, '', '', '日期');
                }
                );
            }
            function findShowingSessionsByCinemaIdAndMovieIdAndShowDate() {
                $.getJSON('http://home.ezding.com.tw/func/ajax_mymovie.php',
                        {'func': 'findShowingSessionsByCinemaIdAndMovieIdAndShowDate', 'data': {'cinemaId': $('#cinemaId').val(), 'movieId': $('#movieId').val(), 'showDate': $('#showDate').val()}},
                function (data) {
                    if (data.errorCode && data.errorCode === '0000')
                        select_setOptions('sessionId', data.msg, '', '', '場次');
                }
                );
            }
        //判斷如果選項為 空值 跳出 提示訊息
           /* function searchMovieByCinema() {
        		alert("gp");
                if ($('#cinemaId').val() == "") 
                {
                    $('#cinemaId').focus();
                    alert("請選擇戲院");
                    return;
                }
                if ($('#movieId').val() == "") {
                    $('#movieId').focus();
                    alert("請選擇影片");
                    return;
                }
                if ($('#showDate').val() == "") {
                    $('#showDate').focus();
                    alert("請選擇日期");
                    return;
                }
                if ($('#sessionId').val() == "") {
                    $('#sessionId').focus();
                    alert("請選擇場次");
                    return;
                }
                if ($('#booking_ticketQuantity').val() == "") {
                    $('#booking_ticketQuantity').focus();
                    alert("請選擇數量");
                    return;
                }

                var url = "http://www.ezding.com.tw/mb.do?action=auto.reserved.seats";
                url += "&cinemaId=" + $('#cinemaId').val();
                url += "&movieId=" + $('#movieId').val();
                url += "&showDate=" + $('#showDate').val();
                url += "&sessionId=" + $('#sessionId').val();
                url += "&ticketQuantity=" + $('#booking_ticketQuantity').val();

                location.href = url;
            }*/
    
            // 輪播
            var timer;
            var n = 0;
            var fadeSpeed = 1000;
            var timerSpeed = 5000;
            var fadeStatus = 'showImg';
            var images = [{ "url" : "images\/index_banner_big2.jpg", 
                            "link": "http:\/\/travel.ezding.com.tw\/pages\/home.php?utm_source=EZDing_Web&utm_medium=H_Leaderboard02&utm_campaign=SummerSP201506"}, 
                          { "url" : "images\/index_banner_big.jpg", 
                            "link": "http:\/\/travel.ezding.com.tw\/event\/summervaction2015\/freetickets.php?utm_source=Travel_Web&utm_medium=H_Tbar_L&utm_content=%E6%9A%91%E5%81%87%E8%A8%82%E6%88%BF%E9%80%81%E9%9B%BB%E5%BD%B1%E7%A5%A8&utm_campaign=EZ%E8%A8%82%E6%9A%91%E6%9C%9F%E8%A8%82%E6%88%BF%E9%80%81%E9%9B%BB%E5%BD%B1%E7%A5%A8_201506_01"}];
            var imageCount = 2;
            
            function imgFadeOut() {
                // 只有一個banner 時，不輸播
                if (images.length == 1)
                    return;

                fadeStatus = 'fadeOut';
                $('#bigBanner').fadeOut(fadeSpeed, function () {
                    fadeStatus = 'fadeIn';
                    imgFadeIn();
                    timer = setTimeout(imgFadeOut, timerSpeed);
                });
            }
            function imgFadeIn() {
                showBigBannerImg(1);
                $('#bigBanner').fadeIn(fadeSpeed, function () {
                    fadeStatus = 'showImg';
                });
            }
            function stopAutoPlay() {
                if ('fadeOut' == fadeStatus) {
                    $("#bigBanner").stop(true, true).stop(true, true);
                    showBigBannerImg(-1);
                }
                else if ('fadeIn' == fadeStatus) {
                    $('#bigBanner').stop(true, true);
                }

                clearTimeout(timer);
            }
            function startAutoPlay() {
                timer = setTimeout(imgFadeOut, timerSpeed);
            }
            function showBigBannerImg(val) {
                n = n + val;
                if (n >= imageCount)
                    n = 0;
                if (n < 0)
                    n = (imageCount - 1);
                $('#bigBanner').css('background-image', 'url(' + images[n].url + ')');
                if (images[n].link.length) {
                    // 		printMsg(images[n].link + ',');
                    $('#bigBanner').prop({'href': images[n].link, 'target': '_blank'});
                }
            }

            //連到FB
            function toEventHomeStay() {
                var url = 'http://goo.gl/0Eiwge';
                //url += '?utm_source=BigBanner0329&utm_medium=BigBanner0329&utm_campaign=BigBanner0329';
                window.open(url);
                $('#event_popup_banner').hide();
            }

            function hideEvent() {
                $('#event_popup_banner').hide();
            }


            var load_hs = 0;
            var load_bb = 0;
            var load_mov_cinema = 0;
            var datepickerSetting = {"changeMonth": true, "changeYear": true, "dateFormat": "yy-mm-dd", "firstDay": 1, "showMonthAfterYear": true, "showAnim": "slideDown", "dayNames": ["\u661f\u671f\u65e5", "\u661f\u671f\u4e00", "\u661f\u671f\u4e8c", "\u661f\u671f\u4e09", "\u661f\u671f\u56db", "\u661f\u671f\u4e94", "\u661f\u671f\u516d"], "dayNamesMin": ["\u65e5", "\u4e00", "\u4e8c", "\u4e09", "\u56db", "\u4e94", "\u516d"], "monthNames": ["\u4e00\u6708", "\u4e8c\u6708", "\u4e09\u6708", "\u56db\u6708", "\u4e94\u6708", "\u516d\u6708", "\u4e03\u6708", "\u516b\u6708", "\u4e5d\u6708", "\u5341\u6708", "\u5341\u4e00\u6708", "\u5341\u4e8c\u6708"], "monthNamesShort": ["\u4e00\u6708", "\u4e8c\u6708", "\u4e09\u6708", "\u56db\u6708", "\u4e94\u6708", "\u516d\u6708", "\u4e03\u6708", "\u516b\u6708", "\u4e5d\u6708", "\u5341\u6708", "\u5341\u4e00\u6708", "\u5341\u4e8c\u6708"], "currentText": "\u4eca\u5929", "closeText": "\u95dc\u9589"};
    
  
            function loadMovieCinema() {
                if (load_mov_cinema == 0) {
                    load_mov_cinema = 1;

                    $.getJSON('http://home.ezding.com.tw/func/ajax_mymovie.php',
                            {'func': 'findValidCinemas', 'data': {}},
                    function (data) {
                        if (data.errorCode && data.errorCode == '0000')
                            select_setOptions('cinemaId', data.msg, '', '', '戲院');
                    }
                    );

                    $('#cinemaId').change(function () {
                        findShowingMoviesByCinemaId();
                    });
                    $('#movieId').change(function () {
                        findShowingShowdatesByCinemaIdAndMovieId();
                    });
                    $('#showDate').change(function () {
                        findShowingSessionsByCinemaIdAndMovieIdAndShowDate();
                    });
                }
            }

            var isShowEvent = 1;
            
            $(function () {
                $('#tab_mov').click(function () {
                    $('#ul_tab').prop('class', 'mov');
                    $('#tab_mov').addClass('active');
                    $('#tab_bb').removeClass('active');
                    $('#tab_hs').removeClass('active');

                    $('#search_mov').show();
                    $('#search_bb').hide();
                    $('#search_hs').hide();
                });
                
                $('#tab_bb').click(function () {
                    $('#ul_tab').prop('class', 'bb');
                    $('#tab_mov').removeClass('active');
                    $('#tab_bb').addClass('active');
                    $('#tab_hs').removeClass('active');

                    $('#search_mov').hide();
                    $('#search_bb').show();
                    $('#search_hs').hide();

                    loadHomeStay();
                });
                
                $('#tab_hs').click(function () {
                    $('#ul_tab').prop('class', 'hs');
                    $('#tab_mov').removeClass('active');
                    $('#tab_bb').removeClass('active');
                    $('#tab_hs').addClass('active');

                    $('#search_mov').hide();
                    $('#search_bb').hide();
                    $('#search_hs').show();

                    loadHotSpring();
                });

                $('#tab_mov_location').click(function () {
                    $('#tab_mov_location').addClass('active');
                    $('#tab_mov_cinema').removeClass('active');

                    $('#search_mov_location').show();
                    $('#search_mov_cinema').hide();
                });
                $('#tab_mov_cinema').click(function () {
                    $('#tab_mov_location').removeClass('active');
                    $('#tab_mov_cinema').addClass('active');

                    $('#search_mov_location').hide();
                    $('#search_mov_cinema').show();

                    loadMovieCinema();
                });

                // movie location
                $('#location').change(function () {
                    findMovieGroupsByLocation();
                });
                $('#mgId').change(function () {
                    findSessionDatesByMovieGroupAndLocation();
                });
                $('#sessionDate').change(function () {
                    changeStartTime(this.value);
                });
                $('#sessionTimeStart').change(function () {
                    changeEndTime(this.value);
                });

                // loadHotSpring();


                // bigBanner 輪播
                $('#bigBannerDiv').hover(
                        // 當滑鼠滑入區塊停止自動播放
                                function () {
                                    stopAutoPlay();
                                },
                                // 當滑鼠移出區塊開始自動播放
                                        function () {
                                            startAutoPlay();
                                        }
                                );
                                showBigBannerImg(0);
                                timer = setTimeout(imgFadeOut, timerSpeed);


                                // event popup banner
                                //if (1 == isShowEvent) $('#event_popup_banner').show();

                            });
        
        			//根據電影編號、日期、時間 取得相對應的所有場次    
				    var request;
					function loadSession(s)
					{	
						//var movie_no = s[s.selectedIndex].id; // get id
						var mgId = document.getElementById('mgId'); //電影編號的id
						var movie_no = mgId[mgId.selectedIndex].id; //選擇到的電影id
						var show_date = document.getElementById('todays_date').value;//日期的數值
						if(mgId.value != '' && show_date.value != '' && show_date != '日期'){
						//alert(show_date.value);
						request = new XMLHttpRequest();
						request.open("GET", "session_Ajax.jsp?movie_no="+movie_no+"&show_date="+show_date, true);
						// 這行是設定 request 要去哪取資料，尚未開始取
						// 第三個參數打 true 可以想成，利用另外一個執行緒處理 Request
						// 第三個參數打 false 可以想成，利用這一個執行緒處理 Request
						
						request.onreadystatechange = updateData;
						// 當記憶體中的瀏覽器狀態改變時，呼叫 updateData 這個 function
						
						request.send(null); // 發動 request 去取資料
						}
					}
					
					function updateData()
					{
						if (request.readyState == 4)
						{		
							//alert(request.responseText);
							var sessionList = document.getElementById('sessionList');//畫面上的
							sessionList.options.length = 0;	//先清空選擇場次裡的所有內容
							//sessionList.options.add(new Option("選擇場次"));
							var opt = document.createElement('option');
							opt.appendChild( document.createTextNode('選擇場次A'));
							opt.value = '';
							sessionList.appendChild(opt);
							
							var myString = request.responseText;
							var splits = myString.split(",");	//將Ajax傳回來的場次資料先用','分割存進陣列，
																//每個元素的內容為SessionID加上show_time
							splits.pop();	//移除陣列中最後一個空值的元素
							
							for(var i = 0;i<splits.length;i++){
								//sessionList.options.add(new Option("" + splits[i], splits[i]));
								var opt = document.createElement('option');
								var item = splits[i].split(" ");	//將SessionID和show_time再以空白分割存進另一個陣列
								opt.appendChild( document.createTextNode(item[1]));				
								opt.id = item[0];
								opt.value = item[1];				
								sessionList.appendChild(opt);	
							}
						}
					}
					function saveSessionInfo(){		
						var sessionList = document.getElementById("sessionList");		
						var opt_id = sessionList[sessionList.selectedIndex].id;		
						//將場次編號session_ID存進隱藏的input裡面
						var session_ID = document.getElementById("session_ID");
						session_ID.value = opt_id;
						//alert(session_ID + " " + show_time);
					}
        </script>
        
    </head>

    <body>
         <%
         MovieDAO dao = new MovieDAODBImpl();
         ArrayList<Movie> list = dao.getAllMovies();
                
                %>
        <div id="fadeMsg"></div>
        <!--Header-->
        <div class="Header">
            <div class="header-width">
                <!--Logo-->
                
                <!--- <a href="" class="header-logo-New">logo</a> -->
                <!--電影連結-->
                <div class="menu">
                    
                    <ul>
                        <li><a href="#">電影連結</a></li>
                    </ul>
                    
                </div>
                
                <div class="member">
                    <!--登入-->
                    <span class="name">
                        <a href="https://www.ezding.com.tw/enduser.do?ezfrom=homestay">登入</a>&nbsp;&nbsp;
                    </span>
                    <a href="#" class="member-menu"><i class="fa fa-bars"></i></a>
                    <!--語言-->
                    <a href="#" class="language">
                        <i class="fa fa-chevron-right"></i><span class="language-cht"></span>
                    </a>
                    <!--TWD-->
                    <a href="#" class="currency">
                        <i class="fa fa-chevron-right"></i>TWD
                    </a>
                    <!--連結-->
                    <div class="submenu-box submenu-member" style="display:none">
                        <ul>
                            <!--
                                <li><a href="#">評價評論</a></li>
                                <li><a href="#">我的收藏</a></li>
                            -->
                            <li><a href="http://www.ezding.com.tw/mbqa.do?action=help.booking">我的優惠</a></li>
                            <li><a href="http://www.ezding.com.tw/enduser.do">個人資料</a></li>
                        </ul>
                    </div>
                </div>
                <!--連結-->
                <div class="submenu">
                    <a href="http://www.ezding.com.tw/cc.do?action=online&amp;ezfrom=homestay" class="service">客服中心</a>
                    <a href="http://www.ezding.com.tw/mbr.do?ezfrom=homestay" class="order-history">訂購記錄</a>
                </div>
            </div>
        </div>
        <!--end Header-->

        <!--左右分頁 -->
        <div class="Banner" id="bigBannerDiv">
            
            <!--左右分頁 -->
            <!-- <a href="#" class="Banner-pic" id="bigBanner" target="_blank" style="display: block; background-image: url();"></a>-->
            <a href="#" class="Banner-pic" id="bigBanner" target="_blank" style="display: block; background-image: url(https://fbcdn-sphotos-g-a.akamaihd.net/hphotos-ak-xta1/t31.0-8/s2048x2048/11402373_1598800753693506_1485574938779458160_o.jpg) "></a>
            <a href="#" class="Banner-btn-left" onclick="showBigBannerImg(-1)"><i class="fa fa-angle-left"></i></a>
            <a href="#" class="Banner-btn-right" onclick="showBigBannerImg(1)"><i class="fa fa-angle-right"></i></a>
            <div class="search-width">
                <div class="search">
                    <div class="search-menu">
                        <!--電影頁面選單-->
                        <ul class="mov" id="ul_tab">
                            <li><a href="#" class="mov active" id="tab_mov">電影</a></li>

                        </ul>
                    </div>

                    <!-- 電影search 表單 -->
                    
                    <div class="search-select" style="display:block" id="search_mov">
                        <div class="search-title">
                            <h3 style="margin-bottom:9px;">線上選位，取票才扣款</h3>
                        </div>
                        <ul class="mov-tag">
                        
                             <li><a href="#" class="active" id="tab_mov_location">哪裡有空位</a></li>
                             
                            <!-- <li><a href="#" id="tab_mov_cinema">影城訂票</a></li>  -->
                            
                        </ul>

                        <!--電影:哪裡有空位-->
                        <div class="mov-select" style="display:block" id="search_mov_location">
                            <!--地區-->
                            <!--<select name="location" id="location" class="search-s1 icon-mov">-->
                            
                            
                            
                            
                            <Form name="movie_select" id="movie_select" action="Select_seat.jsp" method="POST">
                            
                            <select name="location" id="location" class="search-s1 icon-mov">
                                <option value="">地區</option>
                                <option value="1">台北</option>
                                <option value="2">桃園</option>
                                <option value="3">新竹</option>
                                <option value="4">台中</option>

                            </select>
                            <!--選擇電影-->
                            <!--<select name="mgId" id="mgId" class="search-s1 icon-mov">-->
                            <select name="mgId" id="mgId" class="search-s1 icon-mov">
                                <option value="">選擇電影</option>
                                <%for(int i=0;i<list.size();i++){%>
    							<%-- <option value='<%out.print(list.get(i).get_m_name_c());%>'><%out.print(list.get(i).get_m_name_c());%></option> --%>
                        		 <option id='<%out.print(list.get(i).get_m_no());%>' name
                        		 value='<%out.print(list.get(i).get_m_name_c());%>'><%out.print(list.get(i).get_m_name_c());%></option>       
                               			 <%}%>
   								  
                     		<!--	
                                <option value="1">台北</option>
                                <option value="2">桃園</option>
                                <option value="3">新竹</option>
                                <option value="4">台中</option>
                                <option value="5">台南</option>
                                <option value="6">高雄</option>
                                <option value="7">屏東</option>
                                <option value="8">宜蘭</option>
                                <option value="9">苗栗</option>
							--> 

                            </select>
                            <!--幾人-->
                            <!--<select name="ticketQuantity" id="ticketQuantity" class="search-s2 icon-mov">-->
                            <select name="ticketQuantity" id="ticketQuantity" class="search-s2 icon-mov">
                                <option value="">幾人</option>
                                <option value="1">1</option>
                                <option value="2">2</option>
                                <option value="3">3</option>
                                <option value="4">4</option>
                                <option value="5">5</option>
                                <option value="6">6</option>
                            </select>
                            <!--今天-->
                            
                            <!--<select name="sessionDate" id="sessionDate" class="search-s2 icon-mov">
                            <select name="sessionDate" id="sessionDate" class="search-s2 icon-mov">
                                <option value="">今天</option>
                            </select>-->
                            
                            <input name="todays_date" id="todays_date" class="search-s2 icon-mov" value="日期" 
                            onfocus="showCalendarControl(this);" type="text">
                            <select name="sessionList" id="sessionList" class="search-s2 icon-mov" 
                            onmouseover="loadSession(this)" onchange="saveSessionInfo()">
                            <option value="">選擇場次</option>
                            
                            <!--
                            <select name="sessionList" id="sessionList" class="search-s2 icon-mov" 
                            onClick="loadSession(this)" onchange="saveSessionInfo()">
                            <option value="">選擇場次</option>
                            -->
                            
                            
                            </select>
                            <!-- 以下隱藏的input專門儲存選取的場次編號，提供資訊給下一個頁面取用 -->
                            <input type="hidden" id="session_ID" name="session_ID" value="">
                            
                            <!--時段(起)-->
                            
                            <!--<select name="sessionTimeStart" id="sessionTimeStart" class="search-s2 icon-mov">-->
                            <!--
                              <select name="sessionTimeStart" id="sessionTimeStart" class="search-s2 icon-mov">
                                <option value="">時段(起)</option>
                                <option value="07:00">07:00</option>
                                <option value="07:30">07:30</option>
                                <option value="08:00">08:00</option>
                                <option value="08:30">08:30</option>
                                <option value="09:00">09:00</option>
                                <option value="09:30">09:30</option>
                                <option value="10:00">10:00</option>
                                <option value="10:30">10:30</option>
                                <option value="11:00">11:00</option>
                                <option value="11:30">11:30</option>
                                <option value="12:00">12:00</option>
                                <option value="12:30">12:30</option>
                                <option value="13:00">13:00</option>
                                <option value="13:30">13:30</option>
                                <option value="14:00">14:00</option>
                                <option value="14:30">14:30</option>
                                <option value="15:00">15:00</option>
                                <option value="15:30">15:30</option>
                                <option value="16:00">16:00</option>
                                <option value="16:30">16:30</option>
                                <option value="17:00">17:00</option>
                                <option value="17:30">17:30</option>
                                <option value="18:00">18:00</option>
                                <option value="18:30">18:30</option>
                                <option value="19:00">19:00</option>
                                <option value="19:30">19:30</option>
                                <option value="20:00">20:00</option>
                                <option value="20:30">20:30</option>
                                <option value="21:00">21:00</option>
                                <option value="21:30">21:30</option>
                                <option value="22:00">22:00</option>
                                <option value="22:30">22:30</option>
                                <option value="23:00">23:00</option>
                                <option value="23:30">23:30</option>
                                <option value="00:00">00:00</option>
                                <option value="00:30">00:30</option>
                                <option value="01:00">01:00</option>
                                <option value="01:30">01:30</option>
                                <option value="02:00">02:00</option>
                                <option value="02:30">02:30</option>
                                <option value="03:00">03:00</option>
                                <option value="03:30">03:30</option>
                                <option value="04:00">04:00</option>
                                <option value="04:30">04:30</option>
                                <option value="05:00">05:00</option>
                                <option value="05:30">05:30</option>
                                <option value="06:00">06:00</option>
                                <option value="06:30">06:30</option>
                            </select>
                            -->
                            <!--時段(迄)-->
                            <!--<select name="sessionTimeEnd" id="sessionTimeEnd" class="search-s2 icon-mov">-->
                           <!--  
                           	 <select name="sessionTimeEnd" id="sessionTimeEnd" class="search-s2 icon-mov">
                                <option value="">時段(迄)</option>
                                <option value="07:00">07:00</option>
                                <option value="07:30">07:30</option>
                                <option value="08:00">08:00</option>
                                <option value="08:30">08:30</option>
                                <option value="09:00">09:00</option>
                                <option value="09:30">09:30</option>
                                <option value="10:00">10:00</option>
                                <option value="10:30">10:30</option>
                                <option value="11:00">11:00</option>
                                <option value="11:30">11:30</option>
                                <option value="12:00">12:00</option>
                                <option value="12:30">12:30</option>
                                <option value="13:00">13:00</option>
                                <option value="13:30">13:30</option>
                                <option value="14:00">14:00</option>
                                <option value="14:30">14:30</option>
                                <option value="15:00">15:00</option>
                                <option value="15:30">15:30</option>
                                <option value="16:00">16:00</option>
                                <option value="16:30">16:30</option>
                                <option value="17:00">17:00</option>
                                <option value="17:30">17:30</option>
                                <option value="18:00">18:00</option>
                                <option value="18:30">18:30</option>
                                <option value="19:00">19:00</option>
                                <option value="19:30">19:30</option>
                                <option value="20:00">20:00</option>
                                <option value="20:30">20:30</option>
                                <option value="21:00">21:00</option>
                                <option value="21:30">21:30</option>
                                <option value="22:00">22:00</option>
                                <option value="22:30">22:30</option>
                                <option value="23:00">23:00</option>
                                <option value="23:30">23:30</option>
                                <option value="00:00">00:00</option>
                                <option value="00:30">00:30</option>
                                <option value="01:00">01:00</option>
                                <option value="01:30">01:30</option>
                                <option value="02:00">02:00</option>
                                <option value="02:30">02:30</option>
                                <option value="03:00">03:00</option>
                                <option value="03:30">03:30</option>
                                <option value="04:00">04:00</option>
                                <option value="04:30">04:30</option>
                                <option value="05:00">05:00</option>
                                <option value="05:30">05:30</option>
                                <option value="06:00">06:00</option>
                                <option value="06:30">06:30</option>
                            </select>
                            -->
                             <!--送出-->   
                            <div class="btm-w"> 
                            <a href="javascript:check_data()" class="search-btm color-mov">送出</a>
                    <!--    <input type="button" value="Submit" class="search-btm color-mov" OnClick="check_data();">    -->                       
                                
                            </div>
                              </Form>
                        </div>

                        <!--電影：影城訂票-->
                        <div class="mov-select" style="display:none" id="search_mov_cinema">
                            <select name="cinemaId" id="cinemaId" class="search-s1 icon-mov">
                                <option>戲院</option>
                            </select>
                            <select name="movieId" id="movieId" class="search-s1 icon-mov">
                                <option>影片</option>
                            </select>
                            <select name="showDate" id="showDate" class="search-s1 icon-mov">
                                <option>日期</option>
                            </select>
                            <select name="sessionId" id="sessionId" class="search-s2 icon-mov">
                                <option>場次</option>
                            </select>
                            <select name="booking_ticketQuantity" id="booking_ticketQuantity" class="search-s2 icon-mov">
                                <option value="">數量</option>
                                <option value="1">1</option>
                                <option value="2">2</option>
                                <option value="3">3</option>
                                <option value="4">4</option>
                                <option value="5">5</option>
                                <option value="6">6</option>
                            </select>
                            <div class="btm-w">
                                <a href="javascript:searchMovieByCinema()" class="search-btm color-mov">送出</a>
                            </div>
                        </div>

                    </div>
                </div>
            </div>
            <!--加入我們 FB標籤頁面-->
            <div class="app">
                <div class="app-w">
                    <span class="join-txt">加入我們</span>
                    <a href="https://www.facebook.com/sofunezding" class="join-icon" style="background-image:url(images/join_fb.png)">臉書</a>
                    <a href="http://weibo.com/ezding" class="join-icon" style="background-image:url(images/join_wei.png)">微博</a>
                    <a href="#" class="app-icon" style="background-image: url(images/app_google.png);">play APP</a>
                    <a href="#" class="app-icon" style="background-image:url(images/app_ios.png)">iOS APP</a>
                </div>
            </div>
        </div>
        <!--Footer-->
        <!--最線面的 電影連結選單-->
        <div class="Footer">
            <div class="Footer-sitemap">
                
                <div class="Unit01 Unit-padd">
                    <span class="Unit-title">電影</span>
                    <ul class="row2 row-txt">
                        <li><a href="http://www.ezding.com.tw/welcome.do">最新預告</a></li>
                        <li><a href="#">評價評論</a></li>
                        <li><a href="http://www.ezding.com.tw/welcome.do">即將上映電影</a></li>
                        <li><a href="http://www.ezding.com.tw/welcome.do">訂票Top10</a></li>
                    </ul>
                    <span class="row-title padd-top">&gt;各區影城訂票</span>
                    <ul class="row2 row-txt">
                        <li><a href="http://www.ezding.com.tw/mb.do?cinemaId=aa328194963a11e092b89646992d17ea">in89豪華</a></li>
                        <li><a href="http://www.ezding.com.tw/mb.do?cinemaId=46efa950eafa11e38b12000bdb90dba4">樂聲</a></li>
                        <li><a href="http://www.ezding.com.tw/mb.do?cinemaId=79dd632cce7511e2ad6600215edc3df8">新民生</a></li>
                        <li><a href="http://www.ezding.com.tw/mb.do?cinemaId=40288eb0050f542401050f554e7e0674">威秀</a></li>
                        <li><a href="http://www.ezding.com.tw/mb.do?cinemaId=40288eb0050f542401050f55676b1bbc">美麗華大直</a></li>
                        <li><a href="http://www.ezding.com.tw/mb.do?cinemaId=40288eb0050f542401050f5566201ba4">華威</a></li>
                        <li><a href="http://www.ezding.com.tw/mb.do?cinemaId=2c28121ae2c711e292f7000bdb90dba4">屏東中影</a></li>
                    </ul>
                </div>

                <div class="Unit01 Unit-padd">

                </div>

                <div class="Unit01">

                </div>
            </div>
            <div class="foot-logo"></div>
            <div class="foot-menu"></div>
        </div>
    </body>

</html>
