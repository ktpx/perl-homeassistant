## Perl Homeassistant API Package

Perl Package to interface with the Homeassistant API.

API Documentation: https://developers.home-assistant.io/docs/api/rest/

 * get_config 
 * get_state 
 * set_state
 * check_config 
 * get_services 
 * get_events 
 * get_discovery 
 * get_states 
 * get_log 
 * ping 
 * get_history 
 * services 

You need to create an API token in the homeassistant Web interface.

## Examples:

```

use Hass::API;

my $key = "<yoursecrettoken>";
my $url = "http://homeassistant.local:8123";

my $api = Hass::API->new($key, $url);

my %data =  ( entity_id => "media_player.living_room",
              media_content_id => "https://example.com/media/music/example.mp3",
              media_content_type => "music"  ,
            );

my $result = $api->services( "media_player", "play_media]",  %data );

```

Validating Config:
```
sub validate_config {

   print "Validating configuration:\n";
   my $result = check_config();

   if ( defined $result->{'result'} ) {
      print "Status: $result->{'result'} \n";;
   }
}
```
Set a state: 

```
  my $attributes = { brightness  => "100" ,
                     transition  => "5" };

  my %data = ( state => "on" ,
               attributes => $attributes );

  my $res = $hass->set_state("light.office", %data);
```
## Installation

Copy to your distributions perl site_perl folder, ie

```
 /usr/share/perl5/site_perl/Hass/API.pm
```

