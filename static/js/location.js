'use strict';

$('#form').submit(function (ev) {
    ev.preventDefault();

    const formData = {
        city: $("#city").val(),
        state: $("#state").val(),
        zip: $("#zip").val(),
    };

    $.ajax({
        url: '/location/data',
        type: "POST",
        contentType: 'application/json',
        data: JSON.stringify(formData),
        success: (results) => {
            $('#college_table').empty();
            results.forEach(college => {
                $("#college_table").append(`<tr>
            <th>` + college.school_name + `</th>
            <td>`+ college.city + `</td>
            <td>` + college.state + `</td>
            <td>` + college.zip_code + `</td>
            <td>` + college.ugds + `</td>
            <td>` + college.admit_rate + `</td>
            <td><a href=https://{{college.url}}>Website</a></td></tr>`);
            })
        },
        error: (err) => { console.log(err) }
    });
});