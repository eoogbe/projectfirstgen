$(document)
  .on "ajax:success", ".reply-link", (e, data) ->
    $form = $(data)
    $(this).replaceWith $form
    $form.find(".form-control:first").focus()
  .on "page:change", ->
    if $("#new_comment .error").length > 0
      $("html,body").animate { scrollTop: $("#new_comment .error:first").offset().top }, 800
