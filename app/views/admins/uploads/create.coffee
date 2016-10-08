<% if @upload.persisted? %>
  $("#uploads-table").find("tbody").append "<%=j render partial: 'admins/posts/upload', object: @upload %>"
<% else %>
  alert("上传文件失败，请重新再试");
<% end %>
