<% if @upload.id %>
  $("#uploads-table").find("tbody").append "<%=j render partial: 'admin/posts/upload', object: @upload %>"
<% end %>
