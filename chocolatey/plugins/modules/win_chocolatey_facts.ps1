#!powershell

# Copyright: (c) 2018, Ansible Project
# Copyright: (c) 2018, Simon Baerlocher <s.baerlocher@sbaerlocher.ch>
# Copyright: (c) 2018, ITIGO AG <opensource@itigo.ch>
# Copyright: (c) 2020, Chocolatey Software
# GNU General Public License v3.0+ (see LICENSE or https://www.gnu.org/licenses/gpl-3.0.txt)

#Requires -Module Ansible.ModuleUtils.ArgvParser
#Requires -Module Ansible.ModuleUtils.CommandUtil

#AnsibleRequires -CSharpUtil Ansible.Basic

#AnsibleRequires -PowerShell ..module_utils.Common
#AnsibleRequires -PowerShell ..module_utils.Config
#AnsibleRequires -PowerShell ..module_utils.Sources
#AnsibleRequires -PowerShell ..module_utils.Features
#AnsibleRequires -PowerShell ..module_utils.Packages

$ErrorActionPreference = "Stop"
Set-StrictMode -Version 2.0

# Documentation: https://docs.ansible.com/ansible/2.10/dev_guide/developing_modules_general_windows.html#windows-new-module-development
$spec = @{
    options = @{}
    supports_check_mode = $true
}

$module = New-AnsibleModule -Specifications $spec -Arguments $args

$chocoCommand = Get-ChocolateyCommand

$module.Result.ansible_facts = @{
    ansible_chocolatey = @{
        config   = @{}
        feature  = @{}
        sources  = @()
        packages = @()
    }
}

$chocolateyFacts = $module.Result.ansible_facts.ansible_chocolatey
$chocolateyFacts.config = Get-ChocolateyConfig -ChocoCommand $chocoCommand
$chocolateyFacts.feature = Get-ChocolateyFeature -ChocoCommand $chocoCommand
$chocolateyFacts.sources = @(Get-ChocolateySource -ChocoCommand $chocoCommand)
$chocolateyFacts.packages = @(Get-ChocolateyPackage -ChocoCommand $chocoCommand)

# Return result
$module.ExitJson()
