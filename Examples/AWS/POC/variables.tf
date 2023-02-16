variable "prosimo_teamName" {
  type = string
}
variable "prosimo_token" {
  type = string
}
variable "decommission" {
  type = bool
}
variable "configFile" {
  type = string
}
variable "deployment" {
  type = list(any)
}
variable "wait" {
  type = bool
}
variable "connectType" {
  type = string
}
variable "cacheRuleName" {
  type = string
}
variable "performance" {
  type = string
}
variable "multicloud" {
  type = bool
}