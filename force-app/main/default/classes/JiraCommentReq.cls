public class JiraCommentReq{
    public cls_body body;
    public JiraCommentReq(){
        cls_body reqbody = new cls_body();
        this.body = reqbody;
    }
    public class cls_body {
        public String type;	
        public Integer version;
        public cls_content[] content;
        public cls_body(){
            this.type = 'doc';
            this.version = 1;
            this.content = new List<cls_content>();
        }
    }
    public class cls_content {
        public cls_main_content[] content;
        //public String text;
        public String type;	
        public cls_content(){
            this.type ='paragraph';
            this.content = new List<cls_main_content>();
        }
    }
    public class cls_main_content {
        //public cls_content[] content;
        public String text;
        public String type;	
        public cls_main_content(){
            type ='text';
            text ='';
        }
    }
    public static JiraCommentReq parse(String json){
        return (JiraCommentReq) System.JSON.deserialize(json, JiraCommentReq.class);
    }
}