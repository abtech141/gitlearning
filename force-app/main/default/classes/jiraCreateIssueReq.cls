public class jiraCreateIssueReq{
    public jiraCreateIssueReq(){
        cls_project prj = new cls_project();
        cls_description descp =new cls_description();
        cls_issuetype isstyp = new cls_issuetype();
        cls_assignee asgn = new cls_assignee();
        cls_reporter rep = new cls_reporter();
        cls_fields fld = new cls_fields();
        fld.assignee = asgn;
        fld.description = descp;
        fld.issuetype = isstyp ;
        fld.project = prj;
        fld.reporter = rep;
        fld.summary = '';
        this.fields = fld;
    }
    public cls_fields fields;
    public class cls_fields {
        public cls_project project;
        public String summary;	//Case Subject done 112222
        public cls_description description;
        public cls_issuetype issuetype;
        public cls_assignee assignee;
        public cls_reporter reporter;
    }
    public class cls_project {
        public String key;
        public cls_project(){
            this.key ='';
        }
    }
    public class cls_description {
        public String type;	//doc
        public Integer version;	//1
        public cls_desc_content[] content;
        public cls_description(){
            this.type = 'paragraph';
            this.version = 1;
            List<cls_desc_content> lstc = new List<cls_desc_content>();
            this.content = lstc;
        }
    }
     public class cls_desc_content {
        public cls_content[] content;
        public String type;	
       // public String text;	
        public cls_desc_content(){
            this.type ='';
            List<cls_content> lstc = new List<cls_content>();
            this.content = lstc;        }
    }
    public class cls_content {
        //public cls_content[] content;
        public String type;	
        public String text;	
        public cls_content(){
            this.type ='';
            this.text ='';
        }
    }
    public class cls_issuetype {
        public String name;	
        public cls_issuetype(){
            this.name ='';
        }
    }
    public class cls_assignee {
        public String id;	
        public cls_assignee(){
            this.id ='';
        }
    }
    public class cls_reporter {
        public String id;	
        public cls_reporter(){
            this.id ='';
        }
    }
    public static jiraCreateIssueReq parse(String json){
        return (jiraCreateIssueReq) System.JSON.deserialize(json, jiraCreateIssueReq.class);
    }
    
}