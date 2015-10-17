$(document).on "change", "form .user_role", ->
  if $(this).val() in ["undergrad", "grad", "control"]
    $("#school-fields").show()
  else
    $("#school-fields").hide()
