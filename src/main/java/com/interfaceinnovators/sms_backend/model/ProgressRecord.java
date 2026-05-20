package com.interfaceinnovators.sms_backend.model;

/**
 * Stub — Progress records are not part of the current API contract.
 * This class is kept for compilation compatibility only.
 */
public class ProgressRecord {
    private Long id;
    private Long studentId;
    private String subject;
    private String term;
    private Integer year;

    public Long getId() { return id; }
    public void setId(Long id) { this.id = id; }
    public Long getStudentId() { return studentId; }
    public void setStudentId(Long s) { this.studentId = s; }
    public String getSubject() { return subject; }
    public void setSubject(String s) { this.subject = s; }
    public String getTerm() { return term; }
    public void setTerm(String t) { this.term = t; }
    public Integer getYear() { return year; }
    public void setYear(Integer y) { this.year = y; }
}
