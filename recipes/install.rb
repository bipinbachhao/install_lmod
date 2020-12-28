#
# Cookbook:: install_lmod
# Recipe:: install
#
#

include_recipe '::prerequisites'

version = node['install_lmod']['version']
install_root = node['install_lmod']['install_root']
source = "#{install_root}/source/lmod-#{node['install_lmod']['version']}"
download_url = node['install_lmod']['download_url']
prefix = node['install_lmod']['prefix']
lmod_module_root_path = node['install_lmod']['lmod_module_root_path']
lmod_spider_cache_dir = node['install_lmod']['lmod_spider_cache_dir']
lmod_spider_cache_stamp_file = node['install_lmod']['lmod_spider_cache_stamp_file']
lmod_init_bash_file_path = "/etc/profile.d/#{node['install_lmod']['lmod_init_bash_file']}"
lmod_init_csh_file_path = "/etc/profile.d/#{node['install_lmod']['lmod_init_csh_file']}"

[install_root, source, prefix, lmod_module_root_path, lmod_spider_cache_dir].each do |dir|
  directory dir do
    mode '0755'
    action :create
    recursive true
  end
end

git source do
  repository 'https://github.com/TACC/Lmod.git'
  revision version
  action :sync
end

execute 'Install_LMOD' do
  cwd source
  command <<-INSTALL
  ./configure --prefix=#{prefix}\
    --with-module-root-path=#{lmod_module_root_path}\
    --with-spiderCacheDir=#{lmod_spider_cache_dir}\
    --with-updateSystemFn=#{lmod_spider_cache_stamp_file}
  make -j4
  make install
  INSTALL
  creates "#{prefix}/bin/lmod"
end
