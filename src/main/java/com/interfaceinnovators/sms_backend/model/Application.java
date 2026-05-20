package com.interfaceinnovators.sms_backend.model;

/**
 * Stub — Application enrollment is handled via Student (parentAPI.addChild).
 * This class is kept for compilation compatibility only.
 */
public class Application {
    private Long id;
    private String studentFirstName;
    private String studentLastName;
    private String status;

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    public String getStudentFirstName() { return studentFirstName; }
    public void setStudentFirstName(String n) { this.studentFirstName = n; }
    public String getStudentLastName() { return studentLastName; }
    public void setStudentLastName(String n) { this.studentLastName = n; }
    public String getStatus() { return status; }
    public void setStatus(String s) { this.status = s; }
}
