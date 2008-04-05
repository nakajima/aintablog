Event.observe(document, 'dom:loaded', function() {
  var Logouter = {
    click: function(event) {
      $('logout').hide();
      $('confirm').show();
      event.stop();
    },

    confirm: function(event) {
      var element = event.element();
      var result = element.innerHTML;
      if ( result == 'No' ) {
        $('confirm').hide();
        $('logout').show();
        event.stop();
      }
    }
  }

  var Editable = Class.create({
    editFieldTag: 'textarea',
  
    initialize: function(element, options) {
      Object.extend(this, options);
      this.element = $(element);
      this.field = this.parseField();
      this.value = this.element.innerHTML;
      this.setupForm();
      this.setupBehaviors();
    },
    
    parseField: function() {
      var params = new Array;
      var string = this.element.identify();
      var levels = this.element.readAttribute('rel').replace(/(http:|https:|file:)\/\/[^\/]+/, '').split('/').without('');
      levels.each(function(level, i) { if ( i % 2 == 0 ) { params.push(level.gsub(/s$/, '')) } })
      var split = this.element.identify().split('_');
      var attrs = $A(split).select(function(m) { return params.include(m); });
      var field = split.inject(new Array, function(memo, attr) {
        if ( attrs.include(attr) ) {
          memo.push(attr);
          return memo;
        } else {
          if ( !attrs.include(memo.last()) || attr == 'id' ) {
            memo[memo.length - 1] += '_' + attr;
          } else { memo.push(attr) }
          return memo;
        }
      })
      var fieldString = field.join('[');
      (field.length - 1).times(function() { fieldString += ']' });
      console.info(fieldString)
      return fieldString;
    },
    
    setupForm: function() {
      this.editForm = new Element('form', { 'action': this.element.readAttribute('rel'), 'style':'display:none', 'class':'editor' })
      this.editInput = new Element(this.editFieldTag, { 'name':this.field });
      this.editInput.update(this.element.innerHTML);
      var saveInput = new Element('input', { 'type':'submit', 'value':'Save' });
      this.cancelLink = new Element('a', { 'href':'#' }); this.cancelLink.update('Cancel');
      var methodInput = new Element('input', { 'type':'hidden', 'value':'put', 'name':'_method' })
      this.editForm.insert(this.editInput);
      this.editForm.insert(this.cancelLink);
      this.editForm.insert(saveInput);
      this.editForm.insert(methodInput);
      this.element.insert({after: this.editForm });
    },
  
    setupBehaviors: function() {
      this.behaviors = { };
      this.behaviors['edit'] = this.edit.bindAsEventListener(this);
      this.behaviors['save'] = this.save.bindAsEventListener(this);
      this.behaviors['cancel'] = this.cancel.bindAsEventListener(this);
      this.element.observe('click', this.behaviors['edit']);
      this.editForm.observe('submit', this.behaviors['save']);
      this.cancelLink.observe('click', this.behaviors['cancel']);
    },
  
    edit: function(event) {
      this.element.hide();
      this.editForm.show();
      this.editInput.activate();
      event.stop();
    },
  
    save: function(event) {
      var form = event.element();
      var pars = form.serialize();
      var url = form.readAttribute('action');
      form.disable();
      new Ajax.Request(url, {
        method: 'put',
        parameters: pars,
        onSuccess: function(transport) {
          var json = transport.responseText.evalJSON();
          var attr = this.field.replace(/\w+\[(\w+)\]/, '$1');
          this.value = json[attr];
          this.editInput.update(json[attr]);
          this.element.update(json[attr]);
          form.enable();
          this.cancel();
        }.bind(this),
        onFailure: function(transport) {
          this.cancel();
          alert("Your change could not be saved.");
        }.bind(this)
      })
      event.stop();
    },
  
    cancel: function(event) {
      this.element.show();
      this.editInput.update(this.value);
      this.editForm.hide();
      event.stop();
    }
  })
 
  Object.extend(Editable, {
    create: function(element) {
      new Editable(element);
    }
  })
 
  $$('.editable').each(Editable.create);
  $$('#logout').invoke('observe', 'click', Logouter.click);
  $$('#admin #confirm a').invoke('observe', 'click', Logouter.confirm);
});
