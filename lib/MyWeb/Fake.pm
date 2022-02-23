
package MyWeb::Fake;
use Dancer ':syntax';

use File::Slurp qw(read_file write_file);



our $VERSION = '0.1';

use Exporter qw(import);
our @EXPORT_OK = qw(passphrase);

sub passphrase {
    my ($password) = @_;
    return bless { password => $password}, 'Fake';
}

sub generate {
    my ($self) = @_;
    return $self->{password};
}

sub matches {
    my ($self, $password) = @_;
    return $self->{password} eq $password;
}

get '/test2' => sub {
    template 'index';
};


get  '/search2' =>sub {

     my $q =   param('q') ;
     if (defiend $q){
       return   "you said  : $q"
     }
     template 'index';

}
get   '/fk' =>sub {
     my $filename =config->{dwimmer}{json}
     my $json  =  -e  $filename ? read_file $filename:'{}';

    my $data  =from_json  $json;

    template 'index', {data =>$data};
  }


get '/efk'  =>sub {
  return q{
    <h1>Echo with POST</h1>
    <form action="/echo" method="POST">
    <input type="text" name="txt">
    <input type="submit" value="Send">
    </form>
    };
}

get  '/echofk'  =>sub {
    return 'You sent: ' . param('txt');
}

  get '/pageFk' =>sub {
    template 'page'
  }


  post '/page_fk' =>  sub {
    my $filename = config->{dwimmer}{json};
    my $json = -e $filename ? read_file $filename : '{}';
    my $data = from_json $json;
    my $now   = time;
    $data->{$now} = {
        title => params->{title},
        text  => params->{text},
    };

    write_file $filename, to_json($data);
    redirect '/';
};



get '/crfk' => sub {
    my $text = session('txt') // '';
    return qq{
    <h1>Session</h1>
    Currently saved: <b>$text</b><p>
    <form action="/save" method="POST">
    <input type="text" name="txt">
    <input type="submit" value="Send">
    </form>
    <p>
    <a href="/delete">delete text</a>
    };
};

post '/savefk' => sub {
    my $text = param('txt');
    session txt => $text;
    return qq{
        You sent: <b>$text</b><p>
        Check it on the <a href="/">home page</a>
    };

};

get '/deletefk' => sub {
    session txt => undef;
    return 'DONE <a href="/">home</a>';
};

true;
