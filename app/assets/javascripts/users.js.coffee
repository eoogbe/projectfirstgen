$(document).on "change", "form .user_role", ->
  if $(this).val() in ["undergrad", "grad"]
    $("#school-fields").show()
  else
    $("#school-fields").hide()
