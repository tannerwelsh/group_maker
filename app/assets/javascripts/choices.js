$(document).ready(function() {

  $('#project_choices_form').validateOptions();

  $('#project_choices_form').on('change', 'select', function() {
    $(this).parents('form').validateOptions();
  });

});

jQuery.fn.extend({
  disable: function() {
    this.attr('disabled', true);
  },

  enable: function() {
    this.removeAttr('disabled');
  },

  displayErrors: function(message) {
    this.find('#js_validation_errors').text(message).show();
  },

  hideErrors: function() {
    this.find('#js_validation_errors').text('').hide();
  },

  uniqueOptions: function() {
    var btn   = this.find('input[type=submit]');
    var ids   = [];

    this.find('select').each(function(index) {
      ids.push( $(this).val() );
    });

    if (ids.length === $.unique(ids).length) {
      return true;
    } else {
      return false;
    }
  },

  validateOptions: function() {
    var submitBtn = this.find('input[type=submit]');

    if ( this.uniqueOptions() ) {
      this.hideErrors();
      submitBtn.enable();
    } else {
      this.displayErrors('Each option must be unique');
      submitBtn.disable();
    }
  }
});
