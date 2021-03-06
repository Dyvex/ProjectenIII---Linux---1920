# encoding: utf-8
# author: Mesaguy

describe file('/opt/prometheus/scripts/yum.sh') do
    it { should be_file }
    it { should be_executable }
    its('content') { should match /HELP yum_upgrades_pending Yum package pending updates by origin/ }
    its('size') { should > 500 }
    its('mode') { should cmp '0555' }
    its('owner') { should eq 'root' }
    its('group') { should eq 'prometheus' }
end
