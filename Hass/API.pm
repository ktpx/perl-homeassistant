package Hass::API;
#
# Homeassistant Perl API Package 
# Author: Jinxd
#

use strict;
use warnings;
use Carp;
use Scalar::Util qw( blessed );
use LWP::UserAgent;
use JSON;
use URI;

our $VERSION = '2020.09.16';

sub new {

    my ($class, $apikey, $url) = @_;

    my $ua = LWP::UserAgent->new(); 
    my $self = {
        ua  => $ua,
        apiKey => $apikey,
        url -> $url
    };

    bless $self, $class;
    return $self;

}

sub get {
    my ($self, $url, $data) = @_;

    return $self->_api('get', $url, $data);
}

sub post {
    my ($self, $url, $data) = @_;

    return $self->_api('post', $url, $data);
}

sub delete {

    my ($self, $url, %data) = @_;

    return $self->_api('delete', $url, %data);

}

sub ua {
   return $_[0]->{'ua'};
}

sub get_config {

   return $_[0]->get("/api/config");

}

sub _api {
    
    my ($self, $method, $url, $data ) = @_;

    $method = uc $method;

    my $headers = [ 'Content-Type'  => 'application/json; charset=UTF-8', 
                    Authorization => "Bearer $self->{'apiKey'}" ];

    my $path = "$self->{'url'}" . "$url";
    my $response; my $request;

    if ($data) {
       $request = HTTP::Request->new( $method => "$path" , $headers, $data );   
    } else {
       $request = HTTP::Request->new( $method => "$path" , $headers );   
    }
    $response = $self->ua->request($request);

    my $result;

    if ($response->is_success) {
       if ($response->content_type && $response->content_type eq "text/plain") {
          $result = $response->decoded_content;
       } else {
          $result = decode_json($response->decoded_content);
       }
    }
    else {  
       print $response->content;
    }

    return $result;
}

sub get_state {

    my ($self, $entity_id) = @_;

    return $self->get("/api/states/$entity_id");
}

sub set_state {

    my ($self, $entity_id, %data) = @_;

    my $body = encode_json(\%data);

    unless ($entity_id) {
       print "Error: entity_id is required";
    }

    if (not defined($data{'state'})) {
       print "Error: No state attribute defined.";
    }
    
    return $self->post("/api/states/$entity_id", $body);
}

sub check_config {

   return $_[0]->post("/api/config/core/check_config");

}

sub get_services {

   return $_[0]->get("/api/services");

}

sub get_events {

   return $_[0]->get("/api/events");

}

sub get_discovery {

   return $_[0]->get("/api/discovery_info");

}

sub get_states {

   return $_[0]->get("/api/states");

}

sub get_errorlog {

   my @log = $_[0]->get("/api/error_log");

   return @log;

}

sub ping {

   return $_[0]->get("/api");

}

sub get_history {

   my ($self, $params) = @_;
   
   return $self->get("/api/history/period");

}

# Calls a domain service

sub services {

   my ($self, $domain, $service, %data) = @_;

   my $result;

   if (not exists $data{'entity_id'}) {
      $result = $self->post("/api/services/$domain/$service");
   }
   else {
      my $json = encode_json(\%data);
#      $domain = split(/./, $data{'entity_id'});
      $result = $self->post("/api/services/$domain/$service", $json);
   }

   return $result;
}

1;

