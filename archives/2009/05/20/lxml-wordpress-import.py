# -*- coding: utf-8 -*-

import lxml.etree as etree
import sys
from urlparse import urlparse
from textile import textile
import os

if len(sys.argv) < 2:
    print >>sys.stderr, "usage: %s wordpress.2009-05-04.xml " % sys.argv[0]
    sys.exit()
else:
    context = etree.iterparse(sys.argv[1], tag='item')

for event, blog in context:
    #print(etree.tostring(blog, pretty_print=True))
    body = ""
    filename = ""
    tags = Set([])
    for i in blog:
        if i.tag == 'category':
            tags.add(i.text)
        if i.tag == 'title':
            if i.text:
                title = i.text.encode('utf8')
        if i.tag == '{http://wordpress.org/export/1.0/}post_date':
            if i.text:
                pubdate = i.text
        if i.tag == 'link':
            o = urlparse(i.text)
            if o.path and o.path != '/':
                filename = 'test' + os.path.dirname(o.path)
                dir = os.path.abspath('./test/' + o.path)
                if not os.path.exists(dir):
                    print "Creating ", dir
                    os.makedirs(dir)
            else:
                print title, " has no LINK!"
        if i.tag == '{http://purl.org/rss/1.0/modules/content/}encoded':
            if i.text:
                body = textile(i.text.encode('utf8'), encoding='utf8', output='utf8')
        if i.tag == '{http://wordpress.org/export/1.0/}comment':
            for j in i:
                if j.tag == '{http://wordpress.org/export/1.0/}comment_id':
                    id = j.text
                if j.tag == '{http://wordpress.org/export/1.0/}comment_author':
                    username = j.text
                    if not username:
                        username = "Anonymous"
                if j.tag == '{http://wordpress.org/export/1.0/}comment_author_IP':
                    IP = j.text
                if j.tag == '{http://wordpress.org/export/1.0/}comment_date':
                    date = j.text
                if j.tag == '{http://wordpress.org/export/1.0/}comment_content':
                    content = textile(j.text.encode('utf8'), encoding='utf8', output='utf8')
            f = open(os.path.join(dir, "comment_%d._comment" % int(id)), 'w')
            f.write("""
[[!_comment format=mdwn
 username=\"%s\"
 subject=\"%s\"
 date=\"%s\"
 content=\"\"\"
%s
\"\"\"]]
""" % (username.encode('utf8'), IP, date, content))
            f.close()
    if 1:
        if pubdate and title and body and filename:
            f = open(filename + '.mdwn', 'w')
            f.write('[[!meta title="' + title  + '" ]]\n')
            f.write('[[!meta date="' + pubdate + '" ]]\n')
            if tags:
                tags = list(tags)
                tags = "[[!tag %s]]\n" % ' '.join(tags)
                f.write(tags)
                tags = Set([])
            f.write(body)
            f.close()
