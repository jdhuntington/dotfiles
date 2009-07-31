(snippet-with-abbrev-table 'smarty-mode-abbrev-table
   ("form" . "<form action=\"./$.\" method=\"POST\">

</form>")
   ("==" . "{$$.}")
   ("var" . "{$&&{class}->&&{variable}}")
   ("img" . "<img src=\"$${src}\" alt=\"$${alt}\" />$."))


(snippet-with-abbrev-table 'css-mode-abbrev-table
			   ("mp0" . "margin: 0; padding: 0;")
			   ("o" . "{ $. }"))

(snippet-with-abbrev-table 'php-mode-abbrev-table
   ("fun" . "$${public} function $${name}()
{
$.
}

")
   ("tt" . "$this->t['$${variable}'] = $${variable};"))
