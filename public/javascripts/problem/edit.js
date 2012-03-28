

var Problem = {
	init: function (config) {
		$.each(['namebox', 'textbox', 'renderbox', 'renderBtn',
				'saveBtn', 'part'], function(i, v) {
			Problem[v]=config[v];
		});
		console.log(this.part);
		this.id = 0;
		this.bindEvents();
	},

	bindEvents: function(){
		$(document).bind('select/problem-part-select', this.partSelect);
		$(document).bind('select/problem', this.load); // start loading
		$(document).bind('problem/loaded', this.loadSuccess); //finish loading
		this.renderBtn.on('click', function(e) {
			e.preventDefault();
			Problem.render();
		});
		$(document).bind('problem/rendered', this.renderSuccess); // finish rendering
		$(document).bind('problem/save', this.save); // start saving
		this.saveBtn.on('click', function(e) {
			e.preventDefault();
			$(document).trigger('problem/save');
		});
		$(document).bind('problem/saved', this.render); // finish rendering
	},

	partSelect: function(e, part) {
		console.log('part selected: ' + part);
		Problem.part = part;
		$(document).trigger('select/problem', Problem.id);
	},

	render: function() {
		$.ajax({
			url: '/render',
			type: 'POST',
			data: {
				'text': Problem.textbox.val(),
				'size': 16
			},
			dataType: 'json',
			success: function(data) {	$(document).trigger('problem/rendered', data.html); },
			error: function() {	$(document).trigger('error'); },
		});
	},

	renderSuccess: function(e, string) {
		console.log(string);
		Problem.renderbox.html(string);
	},

	load: function(e, problem_id) {
		$.ajax({
			url: '/problems/show/' + problem_id,
			type: 'POST',
			dataType: 'json',
			success: function(data) {$(document).trigger('problem/loaded', data.problem); },
			error: function() {	$(document).trigger('error'); },
		});		
	},

	loadSuccess: function(e, problem) {
		Problem.id = problem.id;
		Problem.namebox.val(problem.name);
		Problem.textbox.val(problem[Problem.part]);
		Problem.render();
	},

	save: function() {
		var _problem = {name: Problem.namebox.val()};
		_problem[Problem.part] = Problem.textbox.val();
		$.ajax({
			url: '/problems/update',
			type: 'POST',
			dataType: 'json',
			data: {
				id: Problem.id,
				problem: _problem
			},
			success: function(data) {$(document).trigger('problem/saved', _problem); },
			error: function() {	$(document).trigger('error', 'Can\'t save'); },
		});
	},

};

var ProblemList = {
	init: function(config) {
		this.list = config.list;
		this.bindEvents();
	},

	bindEvents: function() {
		this.list.on('click', 'a', function(e) {
			e.preventDefault();
			if(ProblemList.active)
				ProblemList.active.removeClass('active');
			$this = $(this); // a element
			ProblemList.active = $this.closest('li');
			ProblemList.active.addClass('active');
			$(document).trigger('select/problem', $this.data('problem_id'));

		});
		$(document).bind('problem/saved', this.changeName); //finish loading, change name if needed
	},

	changeName:function(e, problem) {
		if(problem.name){
			console.log(problem);
			ProblemList.active.find('a').html(problem.name);
		}
	}

};


$(function() {

function updateSpan(span, _text, _id){
	span.data('selected-id', _id).text(_text);
}

$('a.btn.selectable').each(function() {
	var $this = $(this);	// Button
	var id = $this.attr('id'); // Button id
	var $span = $this.find('span.btn-text:first'); // Span with button text
	var $ul = $this.next() // List with other button options
		.on('click', 'li', function(event) {
			event.preventDefault();
			var $li = $(this);
			var li_id = $li.attr('id');
			if( li_id != $span.data('selected-id') ){
				updateSpan( $span, $li.find('a:first').text(), li_id);
				$(document).trigger('select/'+id, li_id);
			}
	});
	var $fst = $ul.children().first();
	updateSpan( $span, $fst.text(), $fst.attr('id') );
});

key('ctrl+s', function() {
	console.log('saving');
	$(document).trigger('problem/save');
});


Problem.init({
	namebox: $('input#problem-name'),
	textbox: $('textarea#problem-edit'),
	renderbox: $('div#problem-render'),
	renderBtn: $('a.btn#btn-render'),
	saveBtn: $('a.btn#btn-save'),
	part: $('a#problem-part-select').find('span.btn-text').data('selected-id')
});


ProblemList.init({
	list: $('ul#problem-list')
});

});




