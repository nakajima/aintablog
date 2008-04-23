// Prototype Extensions/Plugins
var Logger = {
  debug: function(message) {
    return Logger.say(message, 'debug')
  },
  
  info: function(message) {
    return Logger.say(message, 'info')
  },
  
  warn: function(message) {
    return Logger.say(message, 'warn')
  },
  
  say: function(message, level) {
    if ( console && console[level] ) {
      return console[level](message)
    }
  }
};

/*  Protopanel Javascript Library, version 0.0.1
 *  (c) 2008 Pat Nakajima
 *
 *  Protopanel is freely distributable under the terms of an MIT-style license.
 *
 *--------------------------------------------------------------------------*/
var ProtoPanel = {
  Version: '0.0.1'
}

// Introduces Event delegation (http://icant.co.uk/sandbox/eventdelegation)
Object.extend(Event, (function(){
  return {
    delegate: function(element, eventName, targetSelector, handler) {
      var element = $(element);
      function createDelegation(_delegatedEvent) {
        var origin = _delegatedEvent.element();
        if ( origin.match(targetSelector) && (typeof handler == 'function') ){ return handler(_delegatedEvent); }
      };
      element.observe(eventName, createDelegation);
      return element;
    },

    delegators: function(element, eventName, rules) {
      var element = $(element);
      function delegateRule(rule) {
        element.delegate(eventName, rule.key, rule.value)
      }
      $H(rules).each(delegateRule)
      return element;
    }
  }
})())

Element.addMethods({
  delegate: Event.delegate,
  delegators: Event.delegators
})

Object.extend(document, {
  delegate: Event.delegate,
  delegators: Event.delegators
})


// Element extensions for Panels
Object.extend(ProtoPanel, {
  Extensions: {
    activate: function(element) {
      var element = $(element);
      if ( !document.panelManager.panels.include(element) ) { return false; }
      document.panelManager.activate(element);
      return element;
    },

    isActive: function(element) {
      var element = $(element);
      if ( !document.panelManager.panels.include(element) ) { return false; }
      return (document.panelManager.activePanel() === element);
    }
  }
});

Element.addMethods(ProtoPanel.Extensions);

Object.extend(ProtoPanel, {
  Controls: {
    click: function(event) {
      var element = event.element();
      var targetId = element.readAttribute('href').gsub('#', '');
      $(targetId).activate();
    }
  }
});

Object.extend(ProtoPanel, {
  createPanel: function(element){
    var element = $(element);
    if ( element == null ) { return };
    var controlId = '#' + element.identify();
    var control = $$('a').detect(function(link) { return link.readAttribute('href') == controlId });
    if ( control != null ) {
      control.addClassName('_panelControl');
      element.controlId = controlId;
      return element;
    } else { return false; }
  }
});

Object.extend(ProtoPanel, {
  setup: function(options) {
    HistoryManager.start();
    document.panelManager = new ProtoPanel.Manager(options)
  },

  clobber: function() {
    document.panelManager = null;
  },

  // The ProtoPanel manager class is in charge of maintaining order.
  Manager: Class.create({
    // Sets up Panel manager, then binds it to document.
    initialize: function(options) {
      this.panels = new Array;
      this.addPanels(options);
      if ( HistoryManager.currentHash() ) {
        this.activate(HistoryManager.currentHash())
      } else { this.activate(this.activePanel()); }      
    },

    // Grabs all panels, allowing custom selectors to be set.
    addPanels: function(options) {
      options = options || { };
      function add(element) {
        var panel = ProtoPanel.createPanel(element);
        if ( panel ) {
          this.panels.push(panel);
          // Check to see if default panel was specified
          if ( ('#' + document.URL.split('#')[1]) == panel.controlId ) { this.activate(panel); }
        }
      };

      var tagName = options['tagName'] || 'div'; var className = options['className'] || 'panel';
      var parentSelector = options['parentSelector'] ? (options['parentSelector'] + ' ') : '';
      var targetSelector = parentSelector + tagName + '.' + className;
      $$(targetSelector).each(add.bind(this));
    },

    activePanel: function() {
      return this.panels.last();
    },

    activate: function(panel) {
      var panel = $(panel);
      var control = $(panel.controlId);
      if ( control != null ) {
        $$('._panelControl').without(control).invoke('removeClassName', 'active');
        control.addClassName('active');
      }      
      this.panels.without(panel).invoke('hide');
      this.panels = this.panels.without(panel);
      this.panels.push(panel);
      panel.show();
    },

    goBack: function() {
      var panel = this.panels.pop();
      this.panels.unshift(panel);
      this.activate(this.activePanel());
    }
  })
});

Event.observe(document, 'dom:loaded', function() {
  Event.delegate(document, 'click', '._panelControl', ProtoPanel.Controls.click);
  $$('#back').invoke('observe', 'click', function(event) {
    document.panelManager.goBack();
    event.stop();
  })
})

// Allows anchor-based navigation (including back-button compatibility)
// by using a PeriodicalExecuter to check the URL's hash component against
// a cached value. If there's a difference, the active panel is updated
// using the new URL hash component.
var HistoryManager = {
  start: function() {
    HistoryManager.lastHash = HistoryManager.currentHash();
    new PeriodicalExecuter(HistoryManager.check, 0.2);
  },

  check: function(executer) {
    if ( HistoryManager.isNewHash() ) {      
      function activateNew() {
        var hash = HistoryManager.currentHash();
        document.panelManager.activate(hash);
        executer.stop();
        HistoryManager.start();
      }
      
      Try.these(activateNew);
    }
  },

  currentHash: function() {
    var hash = window.location.href.split('#')[1];
    return (typeof hash == 'undefined') ? null : hash;
  },

  isNewHash: function() {
    return HistoryManager.lastHash != HistoryManager.currentHash();
  }
};

// Extensions to Prototype's Form.Element class.
Object.extend(Form.Element, {
  changeSubmit: function(event) {
    function submittify(testElement) {
      var testElement = $(testElement);
      var title = testElement.readAttribute('title');
      if ( title != null && !title.blank() ) {
        testElement.value = title;
        testElement.setStyle({ color: '#777' })
      }
    }
    var element = event.element();
    var inputs = element.select('input[type=submit]');
    inputs.each(submittify);
  }
});

Event.observe(document, 'dom:loaded', function() {
  $$('form').invoke('observe', 'submit', Form.Element.changeSubmit);
});