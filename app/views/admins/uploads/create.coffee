<% if @upload.id %>
  $("#uploads-table").find("tbody").append "<%=j render partial: 'admins/posts/upload', object: @upload %>"
<% end %>
