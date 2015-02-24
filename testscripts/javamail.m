function [ output_args ] = javamail( input_args )
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

import java.io.*;
import java.util.*;
import javax.mail.*; 

xmlfile     = 'DailyRiskReportEmailList.xml';
% 
%     to = xml.xml(fullfile(getpref('Gist','XmlRead'), xmlfile));
%     to = strcat({to.tree.MEMBER(1).EMAIL}, ';');
%     to = strcat(to{:});

    %add to email xmail for signature and contact blurb
                   
    my = security.getuserProperties;

    % set the prefs and java
%     props = java.lang.System.getProperties;
%     props.setProperty(char( ...
%        links.dbmart('defaultDB', 'mailserver', 'auth').Pref), ...
%        char(links.dbmart('defaultDB', 'mailserver', 'auth').ObservationDefault));
%     props.setProperty(char( ...
%        links.dbmart('defaultDB', 'mailserver', 'socketFactory').Pref), ...
%        char(links.dbmart('defaultDB', 'mailserver', 'socketFactory').ObservationDefault));
%     props.setProperty(char( ...
%        links.dbmart('defaultDB', 'mailserver', 'Port').Pref), ...
%        char(links.dbmart('defaultDB', 'mailserver', 'Port').ObservationDefault));


    %   Get system properties
     prop = java.lang.System.getProperties(); 
    % Get the default Session object.
     session = Session.getDefaultInstance(prop);
    % Get a Store object that implements the specified protocol.
     store = session.getStore('imap');  

    %Connect to the current host using the specified username and password.
     store.connect(char(links.dbmart('defaultDB', 'mailserver', 'smtp').ObservationDefault), ...
                   char( links.dbmart('defaultDB', 'mailserver', 'user').ObservationDefault), ...
                   my.get('password'));


    %Create a Folder object corresponding to the given name.
    folder = store.getFolder('inbox');

    % Open the Folder.
    folder.open(Folder.READ_ONLY);

    message = folder.getMessages();

    
    folder.close(true);
    store.close();

%    b = links.email(to, [], subject, body, [], 'outlook', 'olFormatHTML');
%    b = links.email();
    
%    b.mail;




end

import java.io.*;
import java.util.*;
import javax.mail.*; 

public class ReadMail { 

  public static void main(String args[]) throws Exception { 

  String host = "192.168.10.205";
  String user = "test";
  String password = "test"; 

  % Get system properties
   Properties properties = System.getProperties(); 

  % Get the default Session object.
  Session session = Session.getDefaultInstance(properties);

  % Get a Store object that implements the specified protocol.
  Store store = session.getStore("pop3");

  %Connect to the current host using the specified username and password.
  store.connect(host, user, password);

  %Create a Folder object corresponding to the given name.
  Folder folder = store.getFolder("inbox");

  % Open the Folder.
  folder.open(Folder.READ_ONLY);

  Message[] message = folder.getMessages();

  % Display message.
  for (int i = 0; i < message.length; i++) {

  System.out.println("------------ Message " + (i + 1) + " ------------");

  System.out.println("SentDate : " + message[i].getSentDate());
  System.out.println("From : " + message[i].getFrom()[0]);
  System.out.println("Subject : " + message[i].getSubject());
  System.out.print("Message : ");

  InputStream stream = message[i].getInputStream();
  while (stream.available() != 0) {
  System.out.print((char) stream.read());
  }
  System.out.println();
  }

  folder.close(true);
  store.close();
  }
}