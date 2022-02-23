package MyWeb::App;
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

get '/test' => sub {
    template 'index';
};


get '/welcome' => sub {
    return 'Hello World';
};

get  '/search' =>sub {

     my $q =   param('q') ;
     if (defined $q){
       return   "you said  : $q"
     }
     template 'index';
   };


   get  '/config' =>sub {
        my $t   =param("t");
        my $q =   param('q') ;
        my  $cnf  =param("z");
        my $vb =param("vb");
        my $css =  param("css");
        if (defined $q  and   defined $cnf    and  defined $vb   and defined $css   ){
          #return   "you said  : $q"
          template  "index" ,  {q=>$q, cnf =>$cnf,vb=>$vb,css=>$css};
        }
        template 'index';
      };

get '/' => sub {
     my $filename =config->{dwimmer}{json};
     my $json  =  -e  $filename ? read_file $filename:'{}';

    my $data  =from_json  $json;

    template 'index', {data =>$data};
  };

  any qr{.*} => sub {
      status 'not_found';
      template 'special_404', { path => request->path };
  };
get '/e'  =>sub {
  return q{
    <h1>Echo with POST</h1>
    <form action="/echo" method="POST">
    <input type="text" name="txt">
    <input type="submit" value="Send">
    </form>
    };
};

get  '/echo'  => sub {
    return 'You sent: ' . param('txt');

  };

  get '/page' =>sub {
    template 'page'
  };


  post '/page' =>  sub {
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



get '/cr' => sub {
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

post '/save' => sub {
    my $text = param('txt');
    session txt => $text;
    return qq{
        You sent: <b>$text</b><p>
        Check it on the <a href="/">home page</a>
    };

};

get '/delete' => sub {
    session txt => undef;
    return 'DONE <a href="/">home</a>';
};

true;
