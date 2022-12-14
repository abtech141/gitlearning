public class JIRAIssue {

    public class User {
        public String self;
        public String name;
        public String emailAddress;
        //public AvatarUrls avatarUrls;
        public String displayName;
        public Boolean active;
    }

    public class Resolution {
        public String self;
        public String description;
        public String iconUrl;
        public String name;
    }

    public class Fields {
        public String summary;
        public Progress progress;
        public Timetracking timetracking;
        public Issuetype issuetype;
        public Votes votes;
        //SEE BELOW //Old COMMENT: public String resolution;  //JSON2APEX: Object ; String type not necessarily 100% tested
        public List<Resolution> resolution; //JSON2APEX: Object ; List<Resolution> type not necessarily 100% tested ; TODO: May possible be issues where only 1 resolution so no array? Not sure how SF handles this
        public List<Timetracking> fixVersions;
        public DateTime resolutiondate; //JSON2APEX: Object ; DateTime type not necessarily 100% tested ; Example: "2013-04-26T17:40:57.537+0400"
        public String timespent; //JSON2APEX: Object ; String type not necessarily 100% tested ; Example: "3h 20m"
        public User reporter;
        public Integer aggregatetimeoriginalestimate; //JSON2APEX: Object ; Integer type not necessarily 100% tested ; Example: 144000
        public DateTime created;  //JSON2APEX: Object ; DateTime type not necessarily 100% tested ; Example: "2013-04-26T17:40:57.537+0400"
        public DateTime updated;  //JSON2APEX: Object ; DateTime type not necessarily 100% tested ; Example: "2013-04-26T17:40:57.537+0400"
        public String description;  //JSON2APEX: Object ; String type not necessarily 100% tested
        public Priority priority;
        public Date duedate; //JSON2APEX: Object ; Date type not necessarily 100% tested ; Example: 2013-06-10"
        public List<Timetracking> issuelinks;
        public Watches watches;
        public Worklog worklog;
        public List<Timetracking> subtasks;
        public Status status;
        public List<Timetracking> labels;
        public Integer workratio;
        public User assignee;
        public List<Timetracking> attachment;
        public Integer aggregatetimeestimate; //JSON2APEX: Object ; Integer type not necessarily 100% tested ; Example :288000
        public Project project;
        public List<Timetracking> versions;
        public String environment; //JSON2APEX: Object ; String type not necessarily 100% tested
        public Integer timeestimate; //JSON2APEX: Object ; Integer type not necessarily 100% tested ; Example :288000
        public Progress aggregateprogress;
        public DateTime lastViewed; //JSON2APEX: Object ; DateTime type not necessarily 100% tested ; Example: "2013-06-09T18:28:04.122+1200"
        public List<Timetracking> components;
        public Comment comment;
        public Integer timeoriginalestimate; //JSON2APEX: Object ; Integer type not necessarily 100% tested ; Example :288000
        public Integer aggregatetimespent; //JSON2APEX: Object ; Integer type not necessarily 100% tested ; Example :288000
    }

    public class Issuetype {
        public String self;
        public String id;
        public String description;
        public String iconUrl;
        public String name;
        public Boolean subtask;
    }

    public class Comment {
        public Integer startAt;
        public Integer maxResults;
        public Integer total;
        public List<Timetracking> comments;
    }

    // public class AvatarUrls {
    //     public String 16x16;
    //     public String 24x24;
    //     public String 32x32;
    //     public String 48x48;
    // }

    public class Timetracking {
    }

    public class Worklog {
        public Integer startAt;
        public Integer maxResults;
        public Integer total;
        public List<Timetracking> worklogs;
    }

    public class Progress {
        public Integer progress;
        public Integer total;
    }

    public class Priority {
        public String self;
        public String iconUrl;
        public String name;
        public String id;
    }

    public class Status {
        public String self;
        public String description;
        public String iconUrl;
        public String name;
        public String id;
    }

    public class Issue {
        public String id;
        public String self;
        public String key;
        public Fields fields;
    }

    public class Votes {
        public String self;
        public Integer votes;
        public Boolean hasVoted;
    }

    public String webhookEvent;
    public Long timestamp;
    public User user;
    public Issue issue;

    public class Watches {
        public String self;
        public Integer watchCount;
        public Boolean isWatching;
    }

    public class Project {
        public String self;
        public String id;
        public String key;
        public String name;
        // public AvatarUrls avatarUrls;
    }

    
    public static JIRAIssue parse(String json) {
        return (JIRAIssue) System.JSON.deserialize(json, JIRAIssue.class);
    }
    

}