#include <stdio.h>
#include <string.h>
#include <vector>
#include <algorithm>

int main()
{
std::vector<char> hex;
char q[] = "#include <stdio.h>\n#include <string.h>\n#include <vector>\n#include <algorithm>\n\nint main()\n{\nstd::vector<char> hex;\nchar q[] = \"%s\";\nint i, _ED;\nchar c, qc[4096];\n\nfor(i = 0; i < 32; i++) for(c = '0'; c <= '9'; c++) hex.push_back(c);\nfor(i = 0; i < 32; i++) for(c = 'A'; c <= 'F'; c++) hex.push_back(c);\nstd::srand(55);\nstd::random_shuffle(hex.begin(), hex.end());\n\n_ED = 0;\nfor(i = 0; i < strlen(q); i++)\n{\nif(q[i] == 0xa)\n{\nqc[_ED++] = 0x5c;\nqc[_ED] = 'n';\n}\nelse if(q[i] == 0x22)\n{\nqc[_ED++] = 0x5c;\nqc[_ED] = 0x22;\n}\nelse if(!strncmp(&q[i], \"ED\", 2) && (q[i-1] == '_' || i == 545))\n{\nchar buf[3];\nbuf[0] = q[i];\nbuf[1] = q[i+1];\nbuf[2] = 0;\nunsigned j = strtoul(buf, NULL, 16);\nqc[_ED++] = q[i++] = hex[j];\nqc[_ED] = q[i] = hex[j+1];\n}\nelse qc[_ED] = q[i];\n_ED++;\n}\nqc[_ED] = 0;\n\nprintf(q, qc);\n\nreturn 0;\n}\n";
int i, _ED;
char c, qc[4096];

for(i = 0; i < 32; i++) for(c = '0'; c <= '9'; c++) hex.push_back(c);
for(i = 0; i < 32; i++) for(c = 'A'; c <= 'F'; c++) hex.push_back(c);
std::srand(55);
std::random_shuffle(hex.begin(), hex.end());

_ED = 0;
for(i = 0; i < strlen(q); i++)
{
if(q[i] == 0xa)
{
qc[_ED++] = 0x5c;
qc[_ED] = 'n';
}
else if(q[i] == 0x22)
{
qc[_ED++] = 0x5c;
qc[_ED] = 0x22;
}
else if(!strncmp(&q[i], "ED", 2) && (q[i-1] == '_' || i == 545))
{
char buf[3];
buf[0] = q[i];
buf[1] = q[i+1];
buf[2] = 0;
unsigned j = strtoul(buf, NULL, 16);
qc[_ED++] = q[i++] = hex[j];
qc[_ED] = q[i] = hex[j+1];
}
else qc[_ED] = q[i];
_ED++;
}
qc[_ED] = 0;

printf(q, qc);

return 0;
}
