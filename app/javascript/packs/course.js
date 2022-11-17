$(document).on('turbolinks:load', function(){
  console.log("course.js is loaded")

  // handle cocoon for course tag

  // trigers when pushing "add a new tag"
  // works "within" #tags elemet
  $('#tags').on('cocoon:after-insert',
    function(e, tag) {
      console.log('inserting new tag ...');
      // $(".project-tag-fields a.add-tag").
      //     data("association-insertion-position", 'after').
      //     data("association-insertion-node", 'this');

      // bind function for newly created tag
      $(this).find('.course-tag-fields').on('cocoon:after-insert',
        function() {
          console.log('insert new tag ... called when pushing create a new tag for a "new" element ');
          console.log($(this));
          $(this).find(".tag_from_list").remove();
          $(this).find("a.add_fields").hide();
        }
      );
      // $(this).find('.course-tag-fields').on('cocoon:before-insert',
      //   function() {
      //     console.log("tags_remove")
      //     $(this).find(".remove_fields").remove();
      //   }
      // );
    }
  );
  // trigers when pushing "create a new tag" for existing tags
  // works "within" .course-tag-fields elemet
  // $('.course-tag-fields').on('cocoon:before-insert',
  //   function() {
  //     console.log("course-tag-fields_remove")
  //     $(this).find(".remove_fields").remove();
  //   }
  // )
  $('.course-tag-fields').on('cocoon:after-insert',
    function(e) {
        console.log('replace OLD tag ... when pushing create a new tag for an "existing" element ');
        e.stopPropagation();
        console.log($(this));
        $(this).find(".tag_from_list").remove();
        // $(this).find(".remove_fields").remove();
        $(this).find("a.add_fields").hide();
    }
  );
})
