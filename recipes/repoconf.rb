#
# Cookbook:: install_lmod
# Recipe:: repoconf
#
#

case node['platform_family']
when 'debian'

  apt_update 'update' do
    compile_time true
  end

when 'amazon', 'fedora', 'rhel'

  execute 'Enable_PowerTools_Repo' do
    command 'dnf config-manager --set-enabled PowerTools'
    action :run
    only_if { platform?('centos') }
    not_if 'dnf repolist|grep -qi "powertools"'
  end

  package 'epel-release' if platform?('centos')

  execute 'Enable_Epel_Repo' do
    command 'amazon-linux-extras install epel -y'
    action :run
    only_if { platform?('amazon') }
    not_if 'yum repolist|grep -qi "epel"'
  end

  yum_repository 'OL_EPEL_REPO' do
    description 'Oracle EPEL yum repository'
    baseurl "http://yum.oracle.com/repo/OracleLinux/OL#{node['platform_version'].to_i}/developer/EPEL/$basearch/"
    gpgkey 'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-oracle'
    action :create
    only_if { platform?('oracle') }
  end

  yum_repository 'OL_CODEREADY_REPO' do
    description 'Oracle CodeReady yum repository'
    baseurl "http://yum.oracle.com/repo/OracleLinux/OL#{node['platform_version'].to_i}/codeready/builder/$basearch/"
    gpgkey 'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-oracle'
    action :create
    only_if { platform?('oracle') }
  end

end
