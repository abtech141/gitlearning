import { LightningElement } from 'lwc';

export default class HtmlEventbasic extends LightningElement {
message = "Event update";
showtom = false;
contacts = [
    {
        Id : 1,
        Name : "Amit Sing",
        Email : "sfdcpanther@gmail.com"
    },
    {       
        Id : 2,
        Name : "Anuj Sing",
        Email : "anuj@outlook.com"
    },
    {
        Id : 3,
        Name : "Ankit Sing",
        Email : "ankit@hotmail.com"
    }
]
handleChange(event){
    // eslint-disable-next-line no-alert
    alert('input updated');
    console.log('The value is --'+ event.target.value + ' Label is --' + event.target.label);
}

}