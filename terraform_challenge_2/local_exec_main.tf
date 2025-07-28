resource "null_resource" "test" {
  provisioner "local-exec" {
    command = <<EOT
      git clone https://github.com/matriex/cmatrix
      Set-Executionpolicy remotesigned
      Import-Module .\cmatrix
      Set-ScreenSaverTimeout -Seconds 5
      Enable-ScreenSaver
      EOT
  }
}