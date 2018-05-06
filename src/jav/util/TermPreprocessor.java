/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package util;

import java.io.File;
import java.io.IOException;
import java.util.ArrayList;
import java.util.List;
import java.util.Scanner;

/**
 *
 * @author user
 */
public class TermPreprocessor {
    
    public String preprocess(String term){
        String resultTerm = null;
        if(term != null)
            resultTerm = convertToLowerCase(term);
        if(resultTerm != null)
            resultTerm = removePunctuations(resultTerm);
        if(resultTerm != null){
            try{
                resultTerm = removeStopWords(resultTerm);
            }
            catch(IOException e){
                System.out.println("TermPreprocessor IOException");
            } 
        }
        if(resultTerm != null)
            resultTerm = stemming(resultTerm);

        return resultTerm;
    }

    public String convertToLowerCase(String term){
        return term.toLowerCase();
    }

    public String removePunctuations(String term){
        char[] chars = term.toCharArray();
        int length = chars.length;

        int count = 0;
        for(char ch : chars){
            if(!Character.isLetterOrDigit(ch)){
                count++;
            }
        }

        if(count==length)
            return null;
        else
            return term;
    }

    public String removeStopWords(String term) throws IOException{
        String filePath = "C:\\Users\\Nowshad\\Documents\\NetBeansProjects\\pro1\\src\\java\\util\\stopwords.txt";

        Scanner scanner = new Scanner(new File(filePath)); 

        List<String> stopWordList = new ArrayList<>();

        while(scanner.hasNextLine()){
            String line = scanner.nextLine().trim();

            if(line.isEmpty()){
              continue;
            }

            if(line.startsWith("|")){
              continue;
            }

            int firstCommentIndex = line.indexOf("|");
            if(firstCommentIndex != -1){
              line = line.substring(0, firstCommentIndex).trim();
            }

            stopWordList.add(line);
        }

        if(stopWordList.contains(term)){
            return "";
        }
        else{
            return term;
        }
    }
    
    public boolean removeStopWordscheck(String term) throws IOException{
        String filePath = "C:\\Users\\Nowshad\\Documents\\NetBeansProjects\\pro1\\src\\java\\util\\stopwords.txt";

        Scanner scanner = new Scanner(new File(filePath)); 

        List<String> stopWordList = new ArrayList<>();

        while(scanner.hasNextLine()){
            String line = scanner.nextLine().trim();

            if(line.isEmpty()){
              continue;
            }

            if(line.startsWith("|")){
              continue;
            }

            int firstCommentIndex = line.indexOf("|");
            if(firstCommentIndex != -1){
              line = line.substring(0, firstCommentIndex).trim();
            }

            stopWordList.add(line);
        }

        if(stopWordList.contains(term)){
            return false;
        }
        else{
            return true;
        }
    }

    public String stemming(String term){
        Stemmer stemmer = new Stemmer();

        term = term.trim();
        stemmer.add(term.toCharArray(), term.length());
        stemmer.stem();
        return stemmer.toString();
    }

    
}
