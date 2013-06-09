
from docutils import nodes

text = '\xe2\x80\x98int main()\xe2\x80\x99'

print(text)
text = text.decode('utf-8')
node = nodes.literal_block(text, text)

