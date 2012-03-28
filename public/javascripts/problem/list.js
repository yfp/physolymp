$(function() {
	var problem = {
		name: $('span#problem-name'),
		text: $('div#problem-text')
	};

	console.log(problem.text.text('some'));

	$('li')
		.css('cursor', 'pointer')
		.on('click', function() {
			console.log('problems/'+$(this).data('id'));
			$.ajax({
				url: 'problems/'+$(this).data('id'),
				type: 'GET',
				dataType: 'json',
				error: function() {
					alert('Alarma!');
				},
				success: function(data) {
					problem.name.text(data.problem.name);
					problem.text.text(
						'Условие:'+
						data.problem.statement +
						'\n\nРешение:'+
						data.problem.solution +
						'\n\nОтвет:'+
						data.problem.answer
					);
				}, 
			});
		});
});