package com.springboot.service;

import com.springboot.entity.ColumnClass;
import org.springframework.stereotype.Service;

import java.util.*;


public interface CodeGenService {
    void generate(String tableName, String diskPath, String changeTableName, String author, String packageName, String tableAnnotation, String modelName, String suffix, List<ColumnClass> columnClassList) throws Exception;

    List<String> generate(String tableName, String passowrd, String url, String user, String driver, String diskPath, String changeTableName, String author, String packageName, String tableAnnotation, String modelName, String suffix) throws Exception;

    String replaceUnderLineAndUpperCase(String str);

}
