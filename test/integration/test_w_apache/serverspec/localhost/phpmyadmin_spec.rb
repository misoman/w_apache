require 'spec_helper'

describe 'w_apache::phpmyadmin' do

	describe file('/websites/phpmyadmin/config.inc.php') do
	  it { should be_file }
	end

  describe file('/etc/apache2/conf-available/phpmyadmin.conf') do
	  it { should be_file }
	end
	
end