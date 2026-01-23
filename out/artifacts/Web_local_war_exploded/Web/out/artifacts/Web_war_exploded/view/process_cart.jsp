<%@ page import="java.util.*" %>
<%
    String id = request.getParameter("id");
    if (id != null) {
        List<String> cart = (List<String>) session.getAttribute("cart");
        if (cart == null) cart = new ArrayList<>();
        cart.add(id);
        session.setAttribute("cart", cart);
        response.sendRedirect("../Cart");
    }
%>