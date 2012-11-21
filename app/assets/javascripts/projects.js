$(document).ready(function() {

  jQuery.fn.extend({
    // Kudos to @CD_Sanchez for the following
    // src: http://stackoverflow.com/questions/3426404/create-a-hexadecimal-colour-based-on-a-string-with-jquery-javascript

    hashCode: function(str) {
      var hash = 0;
      for (var i = 0; i < str.length; i++) {
         hash = str.charCodeAt(i) + ((hash << 5) - hash);
      }
      return hash;
    },
    
    intToARGB: function(i) {
      return ((i>>24)&0xFF).toString(16) + 
             ((i>>16)&0xFF).toString(16) + 
             ((i>>8)&0xFF).toString(16) + 
             (i&0xFF).toString(16);
    },

    hexFromText: function() {
      return this.intToARGB( this.hashCode($(this).text()) ).slice(0,6)
    }
  });

  $('.project_name').each(function() {
    $(this).css( 'color', ( '#' + $(this).hexFromText() ) );
  });

});
