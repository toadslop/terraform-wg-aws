resource "aws_instance" "edr_wg_instance" {
  ami                    = data.aws_ami.latest_ubuntu.id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.edr_wg_public_subnet.id
  vpc_security_group_ids = ["${aws_security_group.edr_wg_sg.id}"]

  user_data = templatefile(
    "${path.module}/wg.tftpl",
    {
      p1_private_key = var.p1_private_key
      p1_public_key  = var.p1_public_key
      p2_private_key = var.p2_private_key
      p2_public_key  = var.p2_public_key
      wg_ps_key      = var.wg_ps_key
      wireguard_port = var.wireguard_port
    }
  )

  tags = {
    "Name" = "${var.env_prefix}_instance"
  }
}
