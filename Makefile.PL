use 5.008001;
use ExtUtils::MakeMaker;
# See lib/ExtUtils/MakeMaker.pm for details of how to influence
# the contents of the Makefile that is written.
WriteMakefile(
    NAME              => 'ZeroMQ::JSON',
    VERSION_FROM      => 'lib/ZeroMQ/JSON.pm',
    PREREQ_PM         => {
      'ZeroMQ' => '0.01',
      'JSON::Any' => '0',
    },
    ($] >= 5.005 ?
      (ABSTRACT_FROM  => 'lib/ZeroMQ/JSON.pm', # retrieve abstract from module
       AUTHOR         => 'Steffen Mueller <smueller@cpan.org>') : ()),
);
