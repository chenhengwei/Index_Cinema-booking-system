<%-- 
    Document   : Select_seat
    Created on : Aug 25, 2015, 11:38:16 PM
    Author     : chenwesley
--%>

<%@page contentType="text/html" pageEncoding="UTF-8" import="edu.pccu.Movie.*,java.util.*"%>
<!DOCTYPE html>
<html>
    <head>
        <meta http-equiv="Content-Type" content="text/html; charset=utf-8">
        <meta name="viewport" content="width = device-width">
        <link rel="stylesheet" type="text/css" href="jquery.seat-charts.css">
        <script type="text/javascript" src="http://code.jquery.com/jquery-1.11.0.min.js"></script>
        <script type="text/javascript" src="jquery.seat-charts.min.js"></script>
        <link rel="stylesheet" type="text/css" href="css/Comfirm_info.css">
        <link rel="stylesheet" href="css/style.css" type="text/css" media="screen"/>

    </head>
    <body>
        <div id="page">
            <div class="section header clear">

            </div>

            <div class="results"></div>
 			<div style="clear:both"></div>

            <div class="demo">
 				<div style="clear:both"></div>
 				
                <div id="seat-map" class="booking-show-info" tabindex="0" aria-activedescendant="1_0">
				<form name="form1" method="post" action="">
				客戶e-mail： <input name="mail_account" type="text" id="mail_account" value="<%%>">
				客戶Phone： <input name="phone_account" type="text" id="phone_account" value="<%%>">
				<input type="submit" name="Submit" value="搜尋">
				<input type="submit" name="Submit" value="顯示所有訂單">
				</form>

                <div >
				<table class="table1">

			<%
				request.setCharacterEncoding("utf-8");
				String mail_account = request.getParameter("mail_account");
				String phone_account = request.getParameter("phone_account");
				String option = String.valueOf(request.getParameter("Submit"));
				
				AllJoinDAO dao = new AllJoinDAODBImpl();
				
				if(mail_account != null && phone_account != null && phone_account != "" && mail_account != ""){
				ArrayList<AllJoin> join_list = dao.getAllTickets();
		
					join_list = dao.getOrderedTickets(mail_account.trim(),phone_account.trim());
					for (AllJoin ticket : join_list) {
				
			%>
				<thead>
				<tr>
				<th></th>
					<th scope="col" abbr="Starter">訂票資訊</th></tr>
				</thead>
			 <tbody>
					<tr>
			        <th scope="row">訂票序號:</th>
			        <td><%=ticket.getT_ticket_no()%></td>		
			      	</tr>
			 		<tr>
			        <th scope="row">信箱:</th>
			        <td><%=ticket.getMail_account()%></td>		
			      	</tr>
			      	<tr>
			        <th scope="row">手機號碼:</th>
			        <td><%=ticket.getPhone_password()%></td>		
			      	</tr>
			      	<tr>
			        <th scope="row">訂票時間:</th>
			        <td><%=ticket.getOrder_date()%></td>		
			      	</tr>
					<tr>
			        <th scope="row">場次編號:</th>
			        <td><%=ticket.getT_session_ID()%></td>		
			      	</tr>
					<tr>
			        <th scope="row">人數:</th>
			        <td><%=ticket.getPeople()%></td>		
			      	</tr>
					<tr>
			        <th scope="row">電影編號:</th>
			        <td><%=ticket.getS_movie_no()%></td>		
			      	</tr>
					<tr>			      	
			        <th scope="row"> 廳別:</th>
			        <td><%=ticket.getS_room()%></td>		
			      	</tr>
					<tr>			      	
			        <th scope="row"> 播映時間:</th>
			        <td><%=ticket.getShow_date() + " " + ticket.getShow_time()%></td>		
			      	</tr>			
					<tr>			      	
			        <th scope="row"> 座位:</th>
			        <td><%="R" + ticket.getR_axis() + "S" + ticket.getS_axis()%></td>		
			      	</tr>
					<tr>			      	
			        <th scope="row"> 電影名稱:</th>
			        <td><%=ticket.getMovie_name_chinese()%></td>		
			      	</tr>
			      	<tr>
			        <th scope="row"> 電影版本:</th>
			        <td><%=ticket.getVersion()%></td>		
			      	</tr>
			 </tbody>
			 
			 <tfoot>
		      <tr>
		        <th scope="row">刪除訂單:</th>
		        <td><a href="ticket_cancel.jsp?id=<%=ticket.getT_ticket_no()%>"
								onclick=return(confirm('確定取消訂單嗎？'))>取消</a></td>
		
		      </tr>
		    </tfoot>
				<%}}%>
				
				
			</table>
   
                </div>
               <div id="Customer_info">
       

                </div>
                
                
                
                
                
                
                <div style="clear:both"></div>

				
				
            </div>
            
            
            
            
            
					
			
        </div>
        <!--footer-->
        <div class="footer">
            <!-- <h1 class="theme-name"><strong>Goocode.net</strong><span>© 2013 - 2015 GOOCODE</span></h1> -->
        </div>



    </body>
</html>