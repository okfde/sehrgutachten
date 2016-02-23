document.documentElement.className += ' js';
new FontFaceObserver('Poly')
  .check()
  .then(function(){
    document.documentElement.className += ' fonts-loaded';
  });