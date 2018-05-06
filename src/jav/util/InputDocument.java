/*
 * To change this license header, choose License Headers in Project Properties.
 * To change this template file, choose Tools | Templates
 * and open the template in the editor.
 */
package util;

import java.io.File;
import java.io.IOException;
import java.util.Scanner;

/**
 *
 * @author user
 */
class InputDocument {
    
    protected String name;

        protected String content;

        public String loadFile(String filePath){
            StringBuilder sb = new StringBuilder();
            try{
                Scanner scanner = new Scanner(new File(filePath));

                while(scanner.hasNextLine()){
                  sb.append(scanner.nextLine());
                  if(scanner.hasNextLine()){
                    sb.append("\n");
                  }
                }

                setContent(sb.toString());
//                System.out.println(sb.toString());
          }
          catch(IOException e){
            System.out.println("InputDocument File IOException");
          }
                return sb.toString();

        }

        public String getContent() {
                return content;
        }

        public void setContent(String content) {
                this.content = content;
        }
//
//        public String getName() {
//                return name;
//        }
//
//        public void setName(String name) {
//                this.name = name;
//        }
//
//        public String[] getAllTerms() {
//                return createTextExtractor().extractTerms();
//        }
//
//        public String[] getAllSentences() {
//                return createTextExtractor().extractSentences();
//        }
//
//        private TextExtractor createTextExtractor() {
//                TextExtractor b = new TextExtractor();
//                b.setText(getContent());
//                return b;
//        }


    
}
