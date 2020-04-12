'use strict';

$("#form").submit = ev => {
    ev.preventDefault();
    let formData = {
        city: $("#city").val(), // set default val = ''
        state: $("#state").val(),
        zip: $("#zip").val(),
    };

    $.ajax({
        url: '/location/data',
        type: "POST",
        contentType: "application/json",
        data: JSON.stringify(data),
        success: (results) => {
            results.forEach(college => {
                $("#college_table").append(`<tr>
            <th>` + college.school_name + `</th>
            <td>`+ college.city + `</td>
            <td>` + college.state + `</td>
            <td>` + college.zip + `</td>
            <td>` + college.ugds + `</td>
            <td>` + college.admit_rate + `</td>
            <td>` + college.url + `</td></tr>`);
            })
        },
    });
};