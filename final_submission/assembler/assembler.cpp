#include <iostream>
#include <fstream>
#include <string>
#include <sstream>
#include <vector>
#include <map> 
#include <cmath>

using namespace std;

map<string,string> commands_map;

map<string,string> register_map;

map<string,string> branch_map;

void init_maps(){
    // Read all commands from file and initialise maps.
    ifstream file_to_read("commands.txt");
    string line, word, word1;

    while (getline (file_to_read, line)) {
        istringstream ss(line);
        ss >> word;
        ss >> word1;
        commands_map.insert(pair<string,string>(word,word1));
    }
    file_to_read.close();

    register_map["R0"] = "00";
    register_map["R1"] = "01";
    register_map["R2"] = "10";
    register_map["R3"] = "11";

    ifstream file_to_read1("branch_resolve.txt");
     while (getline (file_to_read1, line)) {
        istringstream ss(line);
        ss >> word;
        ss >> word1;
        branch_map.insert(pair<string,string>(word,word1));
    }
    file_to_read1.close();
}

string parse_signed(int number, int size){
    string result = "";

    int counter = size -1;

    if(number < 0){
        int last = -8;
        result = result.append("1");
        counter--;
        while(counter >= 0){
            int power = -1 * pow(2,counter);
            int add = power + last;
            if(add <= number){
                number -= power;
                result = result.append("1");
            }
            else{
                result = result.append("0");
            }
        }
    }
    else if(number > 0){
        while(counter >= 0){
            int power = pow(2,counter);
            if(number >= power){
                number -= power;
                result = result.append("1");
            }
            else{
                result = result.append("0");
            }
            counter --;
        }
    }
    else{
        if(size == 2){
            result = "00";
        }
        else{
            result = "0000";
        }
    }
    
    return result;
}

int main(){

    init_maps();
    
    // open file to read
    ifstream file_to_read("Program1.S"); 
    // open file to write
    ofstream file_to_write("Program1_machine_code.txt");

    string line;
    string word;
    
    int line_number = 0;

    while (getline (file_to_read, line)) {
        // vector to store words
        vector <string> words;
        // line number for debugging
        line_number++;
        // Remove comments from line
        int ind  = line.find("//");
        if(ind >=0){
            line = line.substr(0,ind);
        }
        // Remove empty lines
        if(!line.compare("") || !line.compare("\r")){
            continue;
        }
        // stream to split line into words seperated by spaces.
        istringstream ss(line);

        while(ss >> word){
            words.push_back(word);
        }
        map<string,string>::iterator it;
        it = commands_map.find(words.at(0));
        if (it == commands_map.end()){
            cout << "ERROR: Unknown command found at line "<<line_number<< ". Skipped the line"<< endl;
            continue;
        }
        string op_code = it->second;
        int words_len = words.size();
        // Write op code
        file_to_write << op_code;
        if(words_len == 3){
            
            map<string,string>::iterator itr0;
            itr0 = register_map.find(words.at(1));

            map<string,string>::iterator itr1;
            itr1 = register_map.find(words.at(2));

            // first register
            if(itr0 == register_map.end()){
                cout<< "ERROR: Unknown first register found at line "<<line_number<< endl;
                continue;
            }
            string first_reg = itr0->second;
            file_to_write << first_reg;

             // second register or immediate
            if(itr1 == register_map.end()){
                int number = 0;
                // immediate
                try
                {
                    number = stoi(words[2]);
                }
                catch(const std::exception& e)
                {
                    cout<< "ERROR: stoi failed to convert " << words[2] << " at line "<< line_number << endl;
                    file_to_write << endl;
                    continue;
                }
                string binary = parse_signed(number, 2);
                file_to_write << binary << endl;
            }
            else {
                // register
                string second_reg = itr1->second;
                file_to_write << second_reg << endl;
            }
        }
        else if(words_len == 2){
            int number = 0;
            string cur_word = words[1];
            int len = words[1].size();
            bool num = true;
            for(int i = 0; i< len; i++ ){
                if(!isdigit(cur_word[i])){
                    num = false;
                   break;
                }
            }
            if(len == 4 && num){
                file_to_write << cur_word << endl;
            }
            else {
                map<string,string>::iterator itr_branch;
                itr_branch = branch_map.find(words.at(1));
                if(itr_branch != branch_map.end()){
                    cur_word = itr_branch->second;
                    // If mapped value is a 4 bit number,
                    if(cur_word.size() == 4){
                        file_to_write << cur_word << endl;
                        continue;
                    }
                }
                try
                {
                    number = stoi(cur_word);
                }
                catch(const std::exception& e)
                {
                    cout<< "ERROR: stoi failed to convert " << cur_word << words[2] << " at line "<< line_number << endl;
                    file_to_write << endl;
                    continue;
                }
                string binary = parse_signed(number,4);
                file_to_write << binary << endl;
            }
        }
        else {
            cout << "ERROR: Only found op-code no operands at line "<< line_number << endl;
        }
        
    }

    file_to_write.close();
    return 0;
}