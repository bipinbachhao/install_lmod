#
# Cookbook:: install_lmod
# Recipe:: prerequisites
#
#

lua_version = node['install_lmod']['lua_version']

case node['platform_family']
when 'debian'

  apt_update 'update' do
    compile_time true
  end

  package %W[build-essential tcl tcl-dev lua#{lua_version} lua-bit32:amd64 lua-posix:amd64
    lua-posix-dev liblua#{lua_version}-0:amd64 liblua#{lua_version}-dev:amd64 git environment-modules]

when 'amazon', 'fedora', 'rhel'

  execute 'Enable_PowerTools_Repo' do
    command 'dnf config-manager --set-enabled PowerTools'
    action :run
    only_if { platform?('centos') }
    not_if 'dnf repolist|grep -qi "powertools"'
  end

  package 'epel-release' if platform?('centos')

  package %w[tcl tcl-devel lua lua-devel lua-json lua-lpeg lua-term lua-posix git environment-modules] do
    action :install
  end

end

build_essential 'Install Build Essential' do
  compile_time true
  action :install
end
