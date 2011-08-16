/* Author: Diego Salazar
   Wordlick: Hangman solver
*/

// Tab chooser
$('.tab').each(function() {
	var active_tab = $('a.active', '#tab_toggle'),
		href_parts = active_tab.attr('href').split('#'),
		hash	   = href_parts[href_parts.length - 1];
	
	$('.tab').hide();
	$('#'+ hash).show();
});
$('a', '#tab_toggle').click(function() {
	var href_parts = this.href.split('#'),
		hash	   = href_parts[href_parts.length - 1];
	
	$('.tab').hide();
	$('#'+ hash).show();
	
	$('a', '#tab_toggle').removeClass('active');
	$(this).addClass('active');
	
	return false;
});























